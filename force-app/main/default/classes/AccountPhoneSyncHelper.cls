public class AccountPhoneSyncHelper {
    public static void syncContactPhones(Map<Id, Account> newMap, Map<Id, Account> oldMap) {

        Set<Id> changedAccountIds = new Set<Id>();

        for (Id accId : newMap.keySet()) {
            Account newAcc = newMap.get(accId);
            Account oldAcc = oldMap.get(accId);

            if (newAcc.Phone != oldAcc.Phone) {
                changedAccountIds.add(accId);
            }
        }

        if (changedAccountIds.isEmpty()) {
            return;
        }

        List<Contact> contactsToUpdate = new List<Contact>();

        for (Contact con : [
            SELECT Id, AccountId, HomePhone, OtherPhone
            FROM Contact
            WHERE AccountId IN :changedAccountIds
        ]) {
            Account newAcc = newMap.get(con.AccountId);
            Account oldAcc = oldMap.get(con.AccountId);

            con.HomePhone = newAcc.Phone;
            con.OtherPhone = oldAcc.Phone;
            contactsToUpdate.add(con);
        }

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}