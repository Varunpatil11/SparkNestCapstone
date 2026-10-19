public class EnquiryTriggerHandler implements TriggerDispatcher.ITriggerHandler {
    
    public void beforeInsert() {
        EnquiryService.setInitialRatings((List<Enquiry__c>)Trigger.new);
    }
    
    public void beforeUpdate() {
        // Reserved for future update validation logic
    }
    
    public void afterInsert() {
        EnquiryService.createInitialFollowUpTasks((List<Enquiry__c>)Trigger.new);
    }
    
    public void afterUpdate() {
        EnquiryService.handleStatusChange((Map<Id, Enquiry__c>)Trigger.newMap, (Map<Id, Enquiry__c>)Trigger.oldMap);
    }
}