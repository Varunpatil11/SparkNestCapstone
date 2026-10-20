public class OpportunityTriggerHelper2 {

    public static void setAccountRatingForClosedWon(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {

        Set<Id> accountIdsToUpdate = new Set<Id>();

        for (Id oppId : newMap.keySet()) {
            Opportunity newOpp = newMap.get(oppId);
            Opportunity oldOpp = oldMap.get(oppId);

            Boolean justClosedWon = newOpp.StageName == 'Closed Won' 
                                    && oldOpp.StageName != 'Closed Won';

            if (justClosedWon && newOpp.AccountId != null) {
                accountIdsToUpdate.add(newOpp.AccountId);
            }
        }

        if (accountIdsToUpdate.isEmpty()) {
            return;
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIdsToUpdate) {
            Account acc = new Account(Id = accId, Rating = 'Hot');
            accountsToUpdate.add(acc);
        }

        update accountsToUpdate;
    }
}