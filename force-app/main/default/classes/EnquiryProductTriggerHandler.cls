public with sharing class EnquiryProductTriggerHandler {

    public static void handle(List<Enquiry_Product__c> newList, List<Enquiry_Product__c> oldList) {
        EnquiryProductCountService.recalculate(newList, oldList);
    }
}