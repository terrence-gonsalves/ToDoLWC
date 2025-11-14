public with sharing class TodoItemController {

    /* Constants */

    private static final Set<String> VALID_PRIORITIES = new Set<String> {
        'Low', 'Medium', 'High'
    };

    private static final Set<String> VALID_CATEGORIES = new Set<String> {
        'Work', 'Personal', 'Health and Wellness', 'Family', 'Learning', 'Household', 'Hobbies', 'Financial', 'Other'
    };

    /* Public Methods */

    /**
     * Get all the todo item
     * 
     * @return List<Todo_Item__c>
     * 
    */
    @AuraEnabled(cacheable=true)
    public static List<Todo_Item__c> getTodoItems() {
        return [SELECT Id, Name, Description__c, Due_Date__c, Priority__c, Category__c, Is_Completed__c, Completed_Date__c, OwnerId    
                FROM Todo_Item__c 
                WHERE OwnerId = :UserInfo.getUserId()
                WITH USER_MODE
                ORDER BY Due_Date__c ASC];
    }

    /**
     * Create a new todo item
     * @param title
     * @param description
     * @param dueDate
     * @param priority
     * @param category
     * @throws AuraHandledException
     * 
     * @return Todo_Item__c
     *
     */
    @AuraEnabled
    public static Todo_Item__c createTodoItem(
        String title,
        String description,
        Date dueDate,
        String priority,
        String category
    ) {
        validateTaskFields(title, dueDate, priority);

        String normalisedPriority = validateAndNormalisePriority(priority);
        String normalisedCategory = validateAndNormaliseCategory(category);

        Todo_Item__c todoItem = new Todo_Item__c(
            Name = safeTrim(title),
            Description__c = String.isBlank(description) ? null : safeTrim(description),
            Due_Date__c = dueDate,
            Priority__c = normalisedPriority,
            Category__c = normalisedCategory,
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

    /**
     * Delete a todo item
     * @param todoItemId
     * @throws AuraHandledException
     * 
     * @return void
     *
     */
    @AuraEnabled
    public static void deleteTodoItem(Id todoItemId) {
        if (todoItemId == null) {
            throw new AuraHandledException('Todo item ID is required');
        }

        List<Todo_Item__c> tasks = [SELECT Id FROM Todo_Item__c WHERE Id = :todoItemId WITH USER_MODE];

        if (tasks.isEmpty()) {
            throw new AuraHandledException('Task not found or you do not have access');
        }

        try {
            delete as user tasks;
        } catch (Exception e) {
            System.debug('Error deleting Todo item: ' + e.getMessage());

            throw new AuraHandledException('Could not delete Todo item: ' + e.getMessage());
        }
    }

    /**
     * Update a todo item
     * @param todoItemId
     * @param title
     * @param description
     * @param dueDate
     * @param priority
     * @param category
     * @throws AuraHandledException
     * 
     * @return Todo_Item__c
     *
     */
    @AuraEnabled
    public static Todo_Item__c updateTodoItem(
        Id todoItemId, 
        String title, 
        String description, 
        Date dueDate, 
        String priority, 
        String category
    )  {
        validateTodoId(todoItemId);

        validateTaskFields(title, dueDate, priority); 
        
        String normalizedPriority = validateAndNormalisePriority(priority);
        String normalizedCategory = validateAndNormaliseCategory(category);

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

        existingTask.Name = safeTrim(title);
        existingTask.Description__c = String.isBlank(description) ? null : safeTrim(description);
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

    /**
     * Update the completion status of a todo item
     * @param todoItemId
     * @param isComplete
     * @throws AuraHandledException
     * 
     * @return Todo_Item__c
     *
     */
    @AuraEnabled
    public static Todo_Item__c updateCompletionStatus(Id todoItemId, Boolean isComplete) { 
        validateTodoId(todoItemId);

        if (isComplete == null) {
            throw new AuraHandledException('Completion status is required');
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

        existingTask.Is_Completed__c = isComplete;
        existingTask.Completed_Date__c = isComplete ? Date.today() : null;

        try {
            update as user existingTask;
            return existingTask; 
        } catch (Exception e) {
            System.debug('Error updating task completion status: ' + e.getMessage());
            throw new AuraHandledException('Could not update task completion status: ' + e.getMessage());
        }
    }

    /* Private Methods */

    /**
     * Validates required task fields
     * @param title Task title
     * @param dueDate Task due date
     * @param priority Task priority (High/Medium/Low)
     * @throws AuraHandledException if validation fails
     * 
     * @return void
     */
    private static void validateTaskFields(String title, Date dueDate, String priority) {
        if (String.isBlank(title)) {
            throw new AuraHandledException('Title is required');
        }

        if (dueDate == null) {
            throw new AuraHandledException('Due date is required');
        }

        if (String.isBlank(priority)) {
            throw new AuraHandledException('Priority is required');
        }
    }

    /**
     * Validates required task fields
     * @param Id Task Id
     * @throws AuraHandledException if validation fails
     * 
     * @return void
     */
    private static void validateTodoId(Id todoItemId) {
        if (todoItemId == null) {
            throw new AuraHandledException('Todo item ID is required');
        }
    }

    /**
     * Validates and normalises priority value
     * @param priority Priority string to validate
     * @return Normalized priority value
     * @throws AuraHandledException if priority is invalid
     * 
     * @return String
     */
    private static String validateAndNormalisePriority(String priority) {        
        String normalizedPriority = safeTrim(priority);

        if (!VALID_PRIORITIES.contains(normalizedPriority)) {
            throw new AuraHandledException('Invalid priority');
        }

        return normalizedPriority;
    }

    /**
     * Validates and normalises category value
     * @param category Category string to validate
     * @return Normalized category value
     * @throws AuraHandledException if category is invalid
     * 
     * @return String
     */
    private static String validateAndNormaliseCategory(String category) {
        String normalisedCategory = safeTrim(category);

        if (!VALID_CATEGORIES.contains(normalisedCategory)) {
            throw new AuraHandledException('Invalid category');
        }

        return normalisedCategory;
    }

    /**
     * Safely trims a string, returning null if blank
     * @param value String to 
     * 
     * @return Trimmed string or null
     */
    private static String safeTrim(String value) {
        return value?.trim();
    }
}