public class OpportunityAccountHelper1 {

    public static void recalculateAccountStats(Set<Id> accountIds) {

        Map<Id, Integer> countMap = new Map<Id, Integer>();
        Map<Id, Decimal> amountMap = new Map<Id, Decimal>();

        List<AggregateResult> results = [
            SELECT AccountId, COUNT(Id) oppCount, SUM(Amount) oppTotal
            FROM Opportunity
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ];

        for (AggregateResult ar : results) {
            Id accId = (Id) ar.get('AccountId');
            countMap.put(accId, (Integer) ar.get('oppCount'));
            amountMap.put(accId, (Decimal) ar.get('oppTotal'));
        }

        List<Account> accountsToUpdate = new List<Account>();

        for (Id accId : accountIds) {
            Account acc = new Account(Id = accId);
            acc.Total_Opportunity_Count__c = countMap.containsKey(accId) ? countMap.get(accId) : 0;
            acc.Total_Opportunity_Amount__c = amountMap.containsKey(accId) ? amountMap.get(accId) : 0;
            accountsToUpdate.add(acc);
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}