// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<Todo_Item__c> tasks = TodoItemController.getTodoItems();
System.debug('Number of tasks: ' + tasks.size());
for(Todo_Item__c task : tasks) {
    System.debug('Task: ' + task.Name + ' - Due: ' + task.Due_Date__c);
}