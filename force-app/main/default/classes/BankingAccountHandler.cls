public class BankingAccountHandler {
    public static void handleAfterInsert(List<Account> newAccounts) {
        BankingAccountHelper.createContactsForBankingAccounts(newAccounts);
    }
}