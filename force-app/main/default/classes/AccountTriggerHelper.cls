public class AccountTriggerHelper {
    public static void preventDeletionWithMultipleContacts(List<Account> oldAccounts) {

        Set<Id> accountIds = new Set<Id>();
        for (Account acc : oldAccounts) {
            accountIds.add(acc.Id);
        }

        Map<Id, Integer> contactCountByAccountId = new Map<Id, Integer>();
        for (AggregateResult ar : [
            SELECT AccountId, COUNT(Id) contactCount
            FROM Contact
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            contactCountByAccountId.put((Id) ar.get('AccountId'), (Integer) ar.get('contactCount'));
        }

        for (Account acc : oldAccounts) {
            Integer contactCount = contactCountByAccountId.containsKey(acc.Id)
                ? contactCountByAccountId.get(acc.Id)
                : 0;

            if (contactCount >= 2) {
                acc.addError('This Account cannot be deleted because it has two or more associated Contacts.');
            }
        }
    }
}