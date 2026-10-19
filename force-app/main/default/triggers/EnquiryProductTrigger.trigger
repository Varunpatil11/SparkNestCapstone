trigger EnquiryProductTrigger on Enquiry_Product__c (after insert, after update, after delete, after undelete) {
    EnquiryProductTriggerHandler.handle(Trigger.new, Trigger.old);
}