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
        return null; 
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