public class OpportunityTriggerHandler2 {
    public static void handleAfterUpdate(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {
        OpportunityTriggerHelper2.setAccountRatingForClosedWon(oldMap, newMap);
    }
}