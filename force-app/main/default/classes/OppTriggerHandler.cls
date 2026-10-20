public class OppTriggerHandler {
    public static void handleAccountRecalculation(Set<Id> accountIds) {
        OppTriggerHelper.recalculateAccountStats(accountIds);
    }
}