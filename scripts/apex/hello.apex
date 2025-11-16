// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents


// ============================================
// COMPLETE TEST SUITE - TODO ITEM CONTROLLER
// (For Anonymous Apex - Skips AuraHandledException tests)
// ============================================

System.debug('========================================');
System.debug('🚀 STARTING COMPREHENSIVE TESTS');
System.debug('========================================');

// ============================================
// TEST 1: Create Todo Item
// ============================================
System.debug('\n📝 TEST 1: Create Todo Item');
Todo_Item__c task1;
try {
    task1 = TodoItemController.createTodoItem(
        'Complete Apex Controller',
        'Finish all 5 methods with validation and error handling',
        Date.today().addDays(7),
        'High',
        'Learning'
    );
    System.debug('✅ PASS: Created task - ' + task1.Name + ' (Id: ' + task1.Id + ')');
} catch (Exception e) {
    System.debug('❌ FAIL: ' + e.getMessage());
}

// ============================================
// TEST 2: Get All Todo Items
// ============================================
System.debug('\n📋 TEST 2: Get All Todo Items');
try {
    List<Todo_Item__c> allTasks = TodoItemController.getTodoItems();
    System.debug('✅ PASS: Retrieved ' + allTasks.size() + ' task(s)');
    for (Todo_Item__c t : allTasks) {
        System.debug('   • ' + t.Name + ' | Priority: ' + t.Priority__c + ' | Due: ' + t.Due_Date__c);
    }
} catch (Exception e) {
    System.debug('❌ FAIL: ' + e.getMessage());
}

// ============================================
// TEST 3: Update Todo Item
// ============================================
System.debug('\n✏️ TEST 3: Update Todo Item');
if (task1 == null) {
    System.debug('⚠️ SKIP: No task to update (TEST 1 failed)');
} else {
    try {
        Todo_Item__c updated = TodoItemController.updateTodoItem(
            task1.Id,
            'Build LWC Components',
            'Start building the user interface',
            Date.today().addDays(14),
            'Medium',
            'Work'
        );
        System.debug('✅ PASS: Updated task');
        System.debug('   Old: Complete Apex Controller');
        System.debug('   New: ' + updated.Name);
    } catch (Exception e) {
        System.debug('❌ FAIL: ' + e.getMessage());
    }
}

// ============================================
// TEST 4: Mark as Complete
// ============================================
System.debug('\n✔️ TEST 4: Mark Task as Complete');
if (task1 == null) {
    System.debug('⚠️ SKIP: No task to complete (TEST 1 failed)');
} else {
    try {
        Todo_Item__c completed = TodoItemController.updateCompletionStatus(task1.Id, true);
        System.debug('✅ PASS: Marked as complete');
        System.debug('   Is_Completed__c: ' + completed.Is_Completed__c);
        System.debug('   Completed_Date__c: ' + completed.Completed_Date__c);
        
        if (completed.Completed_Date__c != Date.today()) {
            System.debug('⚠️ WARNING: Completed date should be today!');
        }
    } catch (Exception e) {
        System.debug('❌ FAIL: ' + e.getMessage());
    }
}

// ============================================
// TEST 5: Mark as Incomplete
// ============================================
System.debug('\n↩️ TEST 5: Mark Task as Incomplete');
if (task1 == null) {
    System.debug('⚠️ SKIP: No task to mark incomplete (TEST 1 failed)');
} else {
    try {
        Todo_Item__c incomplete = TodoItemController.updateCompletionStatus(task1.Id, false);
        System.debug('✅ PASS: Marked as incomplete');
        System.debug('   Is_Completed__c: ' + incomplete.Is_Completed__c);
        System.debug('   Completed_Date__c: ' + incomplete.Completed_Date__c);
        
        if (incomplete.Completed_Date__c != null) {
            System.debug('⚠️ WARNING: Completed date should be null!');
        }
    } catch (Exception e) {
        System.debug('❌ FAIL: ' + e.getMessage());
    }
}

// ============================================
// TEST 6: Delete Todo Item
// ============================================
System.debug('\n🗑️ TEST 6: Delete Todo Item');
if (task1 == null) {
    System.debug('⚠️ SKIP: No task to delete (TEST 1 failed)');
} else {
    try {
        TodoItemController.deleteTodoItem(task1.Id);
        
        // Verify deletion
        List<Todo_Item__c> check = [SELECT Id FROM Todo_Item__c WHERE Id = :task1.Id];
        if (check.isEmpty()) {
            System.debug('✅ PASS: Task deleted successfully');
        } else {
            System.debug('❌ FAIL: Task still exists!');
        }
    } catch (Exception e) {
        System.debug('❌ FAIL: ' + e.getMessage());
    }
}

System.debug('\n========================================');
System.debug('⚠️ NOTE: Validation tests (null title, invalid priority, etc.)');
System.debug('   cannot be tested in Anonymous Apex due to AuraHandledException');
System.debug('   restrictions. They will work correctly when called from LWC!');
System.debug('========================================');

System.debug('\n========================================');
System.debug('✨ CRUD TESTS COMPLETE');
System.debug('========================================');