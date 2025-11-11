public with sharing class TodoItemController {
    
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
            Priority__c = String.isBlank(priority) ? null : priority.trim(),
            Category__c = normalizedPriority,
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
        return null;
    }

    @AuraEnabled
    public static Todo_Item__c updateCompletionStatus(Id todoItemId, Boolean isComplete) { 
        return null; 
    }
}

/*
getALl
return [SELECT Id, Name, Description__c, IsComplete__c FROM TodoItem__c];

createTodoItem
insert todoItem;

deleteTodoItem
delete [SELECT Id FROM TodoItem__c WHERE Id = :todoItemId];

updateTodoItem
update todoItem;

toggle
TodoItem__c todoItem = [SELECT Id, IsComplete__c FROM TodoItem__c WHERE Id = :todoItemId];
todoItem.IsComplete__c = isComplete;
update todoIt
*/