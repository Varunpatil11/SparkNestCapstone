public class BankingAccountHelper {
    public static void createContactsForBankingAccounts(List<Account> newAccounts) {

        List<Contact> contactsToInsert = new List<Contact>();

        for (Account acc : newAccounts) {
            if ('Banking'.equals(acc.Industry)) {
                Contact con = new Contact();
                con.LastName = acc.Name;
                con.Phone = acc.Phone;
                con.AccountId = acc.Id;
                contactsToInsert.add(con);
            }
        }

        if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }
    }
}