public class AccountPhoneSyncHandler {
    public static void handleAfterUpdate(Map<Id, Account> newMap, Map<Id, Account> oldMap) {
        AccountPhoneSyncHelper.syncContactPhones(newMap, oldMap);
    }
}