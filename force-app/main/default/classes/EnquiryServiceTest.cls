@isTest
private class EnquiryServiceTest {

    @isTest
    static void testInsertEnquirySetsDefaultPriorityAndCreatesTask() {
        Test.startTest();
        // Insert enquiry without priority to test default assignment
        Enquiry__c enq = TestDataFactory.createEnquiry('Website General Enquiry', null, true);
        Test.stopTest();

        // Verify priority was defaulted to Medium
        Enquiry__c reloadedEnq = [SELECT Id, Priority__c FROM Enquiry__c WHERE Id = :enq.Id];
        System.assertEquals('Medium', reloadedEnq.Priority__c, 'Default priority should be Medium');

        // Verify follow-up task was auto-created
        List<Task> createdTasks = [SELECT Id, Subject, Status, WhatId FROM Task WHERE WhatId = :enq.Id];
        System.assertEquals(1, createdTasks.size(), 'A follow-up task should be created');
        System.assertEquals('Not Started', createdTasks[0].Status, 'Task status should be Not Started');
    }

    @isTest
    static void testClosingEnquiryAutoCompletesTask() {
        // Create enquiry and verify initial task
        Enquiry__c enq = TestDataFactory.createEnquiry('Pricing Request', 'High', true);
        
        Test.startTest();
        // Update status to Closed
        enq.Status__c = 'Closed';
        update enq;
        Test.stopTest();

        // Verify task was marked Completed
        List<Task> tasks = [SELECT Id, Status FROM Task WHERE WhatId = :enq.Id];
        System.assertEquals(1, tasks.size(), 'Task should exist');
        System.assertEquals('Completed', tasks[0].Status, 'Open task should be marked Completed when enquiry is Closed');
    }

    @isTest
    static void testBulkEnquiryInsert() {
        Test.startTest();
        // Test bulk creation (200 records to test governor limits)
        List<Enquiry__c> bulkEnquiries = TestDataFactory.createBulkEnquiries(200, true);
        Test.stopTest();

        // Verify all 200 tasks were created without hitting limits
        List<Task> allTasks = [SELECT Id FROM Task WHERE WhatId IN :bulkEnquiries];
        System.assertEquals(200, allTasks.size(), 'Bulk insert should create 200 tasks without hitting governor limits');
    }
}