public class OpportunityTriggerHandlerFA {

    public static void beforeUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        OpportunityTriggerHelper.setClosedWonFields(newList, oldMap);
    }

    public static void afterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        OpportunityTriggerHelperFA.processClosedWonOpportunities(newList, oldMap);
    }
}