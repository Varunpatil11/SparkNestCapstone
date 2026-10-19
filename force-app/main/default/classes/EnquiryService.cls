public class EnquiryService {
    
    // Set default priority if not specified on new Enquiries
    public static void setInitialRatings(List<Enquiry__c> enquiries) {
        for (Enquiry__c enq : enquiries) {
            if (String.isBlank(enq.Priority__c)) {
                enq.Priority__c = 'Medium';
            }
        }
    }
    
    // Automatically create a follow-up task upon enquiry creation
    public static void createInitialFollowUpTasks(List<Enquiry__c> enquiries) {
        List<Task> tasksToCreate = new List<Task>();
        for (Enquiry__c enq : enquiries) {
            Task t = new Task();
            t.Subject = 'Follow up: ' + (String.isNotBlank(enq.Subject__c) ? enq.Subject__c : enq.Name);
            t.WhatId = enq.Id;
            t.ActivityDate = System.today().addDays(3);
            t.Status = 'Not Started';
            t.Priority = 'Normal'; // Task Priority standard picklist accepts 'Normal'
            tasksToCreate.add(t);
        }
        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
    }
    
    // Auto-complete open tasks if enquiry status transitions to Closed
    public static void handleStatusChange(Map<Id, Enquiry__c> newMap, Map<Id, Enquiry__c> oldMap) {
        Set<Id> closedEnquiryIds = new Set<Id>();
        for (Id enqId : newMap.keySet()) {
            if (newMap.get(enqId).Status__c == 'Closed' && oldMap.get(enqId).Status__c != 'Closed') {
                closedEnquiryIds.add(enqId);
            }
        }
        
        if (!closedEnquiryIds.isEmpty()) {
            List<Task> openTasks = [
                SELECT Id, Status 
                FROM Task 
                WHERE WhatId IN :closedEnquiryIds 
                  AND IsClosed = false
            ];
            for (Task t : openTasks) {
                t.Status = 'Completed';
            }
            if (!openTasks.isEmpty()) {
                update openTasks;
            }
        }
    }
}