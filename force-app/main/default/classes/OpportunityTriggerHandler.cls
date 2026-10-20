public with sharing class OpportunityTriggerHandler {

    public static void beforeUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        OpportunityTriggerHelper.trackNegotiationStageDuration(newOpps, oldOppMap);
    }

    public static void afterInsert(List<Opportunity> newOpps) {
        OpportunityTriggerHelper.handleAfterInsert(newOpps);
    }

    public static void afterUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        OpportunityTriggerHelper.handleAfterUpdate(newOpps, oldOppMap);
    }

    public static void afterDelete(List<Opportunity> oldOpps) {
        OpportunityTriggerHelper.handleAfterDelete(oldOpps);
    }

    public static void afterUndelete(List<Opportunity> newOpps) {
        OpportunityTriggerHelper.handleAfterUndelete(newOpps);
    }
}