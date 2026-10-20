public class OpportunityTriggerHandler1 {
    public static void handleAfterInsert(List<Opportunity> newOpps) {
        OpportunityTriggerHelper1.addSalesManagerToHighValueOpps(newOpps);
    }
}