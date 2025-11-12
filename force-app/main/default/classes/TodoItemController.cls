public with sharing class TodoItemController {

    /* Constants */
    private static final Set<String> VALID_PRIORITIES = new Set<String> {
        'Low', 'Medium', 'High'
    };

    private static final Set<String> VALID_CATEGORIES = new Set<String> {
        'Work', 'Personal', 'Health and Wellness', 'Family',
        'Learning', 'Household', 'Hobbies', 'Financial', 'Other'
    };
    
    @AuraEnabled(cacheable=true)
    public static List<Todo_Item__c> getTodoItems() {
        return [SELECT Id, Name, Description__c, Due_Date__c, Priority__c, Category__c, Is_Completed__c, Completed_Date__c, OwnerId    
                FROM Todo_Item__c 
                WHERE OwnerId = :UserInfo.getUserId()
                WITH USER_MODE
                ORDER BY Due_Date__c ASC];
    }

    @AuraEnabled
    public static Todo_Item__c createTodoItem(
        String title,
        String description,
        Date dueDate,
        String priority,
        String category
    ) { 
        if (String.isBlank(title)) {
            throw new AuraHandledException('Title is required');
        }

        if (dueDate == null) {
            throw new AuraHandledException('Due date is required');
        }

        if (String.isBlank(priority)) {
            throw new AuraHandledException('Priority is required');
        }

        String normalizedPriority = priority?.trim();

        if (normalizedPriority != 'Low' && normalizedPriority != 'Medium' && normalizedPriority != 'High') {
            throw new AuraHandledException('Priority must be one of the following: Low, Medium, High');
        }

        Todo_Item__c todoItem = new Todo_Item__c(
            Name = title.trim(),
            Description__c = String.isBlank(description) ? null : description.trim(),
            Due_Date__c = dueDate,
            Priority__c = normalizedPriority,
            Category__c = category?.trim(),
            Is_Completed__c = false,
            Completed_Date__c = null
        );

        try {
            insert as user todoItem;
            return todoItem;
        } catch (Exception e) {
            System.debug('Error creating task: ' + e.getMessage());
            
            throw new AuraHandledException('Could not create task: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteTodoItem(Id todoItemId) {}

    @AuraEnabled
    public static Todo_Item__c updateTodoItem(
        Id todoItemId, 
        String title, 
        String description, 
        Date dueDate, 
        String priority, 
        String category
    )  {

        if (todoItemId == null) {
            throw new AuraHandledException('Todo item ID is required');
        }

        if (String.isBlank(title)) {
            throw new AuraHandledException('Title is required');
        }

        if (dueDate == null) {
            throw new AuraHandledException('Due date is required');
        }

        if (String.isBlank(priority)) {
            throw new AuraHandledException('Priority is required');
        }

        String normalizedPriority = priority?.trim();

        if (normalizedPriority != 'Low' && normalizedPriority != 'Medium' && normalizedPriority != 'High') {
            throw new AuraHandledException('Priority must be one of the following: Low, Medium, High');
        }      

        String normalizedCategory = String.isBlank(category) ? null : category.trim();

        if (normalizedCategory != null) {
            Set<String> validCategories = new Set<String>{
                'Work', 'Personal', 'Health and Wellness', 'Family', 
                'Learning', 'Household', 'Hobbies', 'Financial', 'Other'
            };
            
            if (!validCategories.contains(normalizedCategory)) {
                throw new AuraHandledException('Invalid category. Must be one of: ' + 
                    String.join(new List<String>(validCategories), ', '));
            }
        }

        List<Todo_Item__c> tasks = [
            SELECT Id, Name, Description__c, Due_Date__c, Priority__c, Category__c, Is_Completed__c, Completed_Date__c 
            FROM Todo_Item__c 
            WHERE Id = :todoItemId 
            WITH USER_MODE
        ];

        if (tasks.isEmpty()) {
            throw new AuraHandledException('Task not found or you do not have access');
        }
        
        Todo_Item__c existingTask = tasks[0];

        existingTask.Name = title.trim();
        existingTask.Description__c = String.isBlank(description) ? null : description.trim();
        existingTask.Due_Date__c = dueDate;
        existingTask.Priority__c = normalizedPriority;
        existingTask.Category__c = normalizedCategory;

        try {
            update as user existingTask;
            return existingTask;
        } catch (Exception e) {
            System.debug('Error updating task: ' + e.getMessage());
            
            throw new AuraHandledException('Could not update task: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static Todo_Item__c updateCompletionStatus(Id todoItemId, Boolean isComplete) { 
        return null; 
    }
}

/*

deleteTodoItem
delete [SELECT Id FROM TodoItem__c WHERE Id = :todoItemId];

updateTodoItem
update todoItem;

toggle
TodoItem__c todoItem = [SELECT Id, IsComplete__c FROM TodoItem__c WHERE Id = :todoItemId];
todoItem.IsComplete__c = isComplete;
update todoIt
*/