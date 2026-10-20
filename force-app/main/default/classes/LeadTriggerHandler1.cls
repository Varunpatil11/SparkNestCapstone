public class LeadTriggerHandler1 {
    public static void handleBeforeInsert(List<Lead> newLeads) {
        Lead1OwnerHelper.assignWebLeadsToSalesUser(newLeads);
    }
}