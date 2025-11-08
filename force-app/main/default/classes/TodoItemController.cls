public with sharing class TodoItemController {
    
    @AuraEnabled(cacheable=true)
    public static List<TodoItem__c> getTodoItems() {}

    @AuraEnabled
    public static void createTodoItem(TodoItem__c todoItem) {}

    @AuraEnabled
    public static void deleteTodoItem(Id todoItemId) {}

    @AuraEnabled
    public static void updateTodoItem(TodoItem__c todoItem) {}

    @AuraEnabled
    public static void toggleTodoItem(Id todoItemId, Boolean isComplete) {}
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