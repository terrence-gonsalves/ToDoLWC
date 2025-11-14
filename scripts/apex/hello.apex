// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents


// ============================================
// TEST SUITE FOR TODO ITEM CONTROLLER
// ============================================

System.debug('========================================');
System.debug('STARTING TESTS');
System.debug('========================================');

// ============================================
// TEST 1: Create Todo Item
// ============================================
System.debug('\n--- TEST 1: Create Todo Item ---');
try {
    Todo_Item__c task1 = TodoItemController.createTodoItem(
        'Test Task 1',
        'Testing create method',
        Date.today().addDays(5),
        'High',
        'Work'
    );
    System.debug('✅ PASS: Created task with Id: ' + task1.Id);
} catch (Exception e) {
    System.debug('❌ FAIL: ' + e.getMessage());
}

// ============================================
// TEST 2: Get All Todo Items
// ============================================
System.debug('\n--- TEST 2: Get All Todo Items ---');
try {
    List<Todo_Item__c> allTasks = TodoItemController.getTodoItems();
    System.debug('✅ PASS: Retrieved ' + allTasks.size() + ' tasks');
    for (Todo_Item__c t : allTasks) {
        System.debug('  - ' + t.Name + ' (Due: ' + t.Due_Date__c + ')');
    }
} catch (Exception e) {
    System.debug('❌ FAIL: ' + e.getMessage());
}

// ============================================
// TEST 3: Update Todo Item
// ============================================
System.debug('\n--- TEST 3: Update Todo Item ---');
try {
    // Get first task
    List<Todo_Item__c> tasks = TodoItemController.getTodoItems();
    if (!tasks.isEmpty()) {
        Todo_Item__c updated = TodoItemController.updateTodoItem(
            tasks[0].Id,
            'Updated Title',
            'Updated description',
            Date.today().addDays(10),
            'Medium',
            'Personal'
        );
        System.debug('✅ PASS: Updated task: ' + updated.Name);
    } else {
        System.debug('⚠️ SKIP: No tasks to update');
    }
} catch (Exception e) {
    System.debug('❌ FAIL: ' + e.getMessage());
}

// ============================================
// TEST 4: Delete Todo Item
// ============================================
System.debug('\n--- TEST 4: Delete Todo Item ---');
try {
    // Create a task to delete
    Todo_Item__c taskToDelete = TodoItemController.createTodoItem(
        'Delete Me',
        'This will be deleted',
        Date.today(),
        'Low',
        null
    );
    Id deleteId = taskToDelete.Id;
    
    // Delete it
    TodoItemController.deleteTodoItem(deleteId);
    
    // Verify deleted
    List<Todo_Item__c> check = [SELECT Id FROM Todo_Item__c WHERE Id = :deleteId];
    if (check.isEmpty()) {
        System.debug('✅ PASS: Task deleted successfully');
    } else {
        System.debug('❌ FAIL: Task still exists after delete');
    }
} catch (Exception e) {
    System.debug('❌ FAIL: ' + e.getMessage());
}

// ============================================
// TEST 5: Error Handling - Null Title
// ============================================
System.debug('\n--- TEST 5: Error Handling - Null Title ---');
try {
    TodoItemController.createTodoItem(
        null,  // Invalid!
        'Description',
        Date.today(),
        'High',
        'Work'
    );
    System.debug('❌ FAIL: Should have thrown exception for null title');
} catch (Exception e) {
    System.debug('✅ PASS: Correctly caught error: ' + e.getMessage());
}

System.debug('\n========================================');
System.debug('TESTS COMPLETE');
System.debug('========================================');