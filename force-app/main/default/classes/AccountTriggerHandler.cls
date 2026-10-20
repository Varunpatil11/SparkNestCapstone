public class AccountTriggerHandler {
    public static void handleBeforeDelete(List<Account> oldAccounts) {
        AccountTriggerHelper.preventDeletionWithMultipleContacts(oldAccounts);
    }
}