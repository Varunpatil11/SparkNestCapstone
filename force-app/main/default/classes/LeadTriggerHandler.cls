public with sharing class LeadTriggerHandler {

    public static void beforeInsert(List<Lead> newLeads) {
        LeadTriggerHelper.checkDuplicateEmail(newLeads, null);
    }

    public static void beforeUpdate(List<Lead> newLeads, Map<Id, Lead> oldLeadMap) {
        LeadTriggerHelper.checkDuplicateEmail(newLeads, oldLeadMap);
        LeadTriggerHelper.validateLeadConversionPhone(newLeads, oldLeadMap);
    }
}