public class OpportunityTriggerHelperFA {

    //    BEFORE UPDATE: fields on the Opportunity itself 
    public static void setClosedWonFields(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        for (Opportunity o : newList) {
            Opportunity oldOpp = oldMap.get(o.Id);
            if (isJustClosedWon(o, oldOpp)) {
                o.CloseDate = Date.today();
                o.Type = 'New Customer';
            }
        }
    }

    //     AFTER UPDATE: cross-object work (Account + Team Member) 
    public static void processClosedWonOpportunities(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {

        Set<Id> accountIds = new Set<Id>();
        List<Opportunity> highValueOpps = new List<Opportunity>();

        for (Opportunity o : newList) {
            Opportunity oldOpp = oldMap.get(o.Id);
            if (isJustClosedWon(o, oldOpp) && o.AccountId != null) {
                accountIds.add(o.AccountId);
                if (o.Amount != null && o.Amount > 5000000) {
                    highValueOpps.add(o);
                }
            }
        }

        if (accountIds.isEmpty()) {
            return;
        }

        updateAccountRatingAndTotals(accountIds);

        if (!highValueOpps.isEmpty()) {
            addSalesManagerToOpportunityTeam(highValueOpps);
        }
    }

    //  Shared guard: only act on the transition INTO Closed Won 
    private static Boolean isJustClosedWon(Opportunity newOpp, Opportunity oldOpp) {
        return newOpp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won';
    }

    //   Account Rating + recalculated totals 
    private static void updateAccountRatingAndTotals(Set<Id> accountIds) {

        List<AggregateResult> results = [
            SELECT AccountId, COUNT(Id) oppCount, SUM(Amount) totalAmount
            FROM Opportunity
            WHERE AccountId IN :accountIds AND StageName = 'Closed Won'
            GROUP BY AccountId
        ];

        Map<Id, Integer> countByAccount = new Map<Id, Integer>();
        Map<Id, Decimal> sumByAccount = new Map<Id, Decimal>();

        for (AggregateResult ar : results) {
            Id accId = (Id) ar.get('AccountId');
            countByAccount.put(accId, (Integer) ar.get('oppCount'));
            sumByAccount.put(accId, (Decimal) ar.get('totalAmount'));
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIds) {
            Account acc = new Account(Id = accId);
            acc.Rating = 'Hot';
            acc.Total_Opportunities__c = countByAccount.containsKey(accId) ? countByAccount.get(accId) : 0;
            acc.Total_Opportunity_Amount__c = sumByAccount.containsKey(accId) ? sumByAccount.get(accId) : 0;
            accountsToUpdate.add(acc);
        }

        update accountsToUpdate;
    }

    //  Add designated Sales Manager for high-value deals 
    private static void addSalesManagerToOpportunityTeam(List<Opportunity> highValueOpps) {

        Opportunity_Team_Setting__mdt setting = Opportunity_Team_Setting__mdt.getInstance('Default');
        if (setting == null || String.isBlank(setting.Sales_Manager_Username__c)) {
            return;
        }

        List<User> salesManagers = [
            SELECT Id FROM User WHERE Username = :setting.Sales_Manager_Username__c LIMIT 1
        ];
        if (salesManagers.isEmpty()) {
            return;
        }

        Id salesManagerId = salesManagers[0].Id;

        List<OpportunityTeamMember> teamMembersToInsert = new List<OpportunityTeamMember>();
        for (Opportunity o : highValueOpps) {
            if (o.OwnerId == salesManagerId) {
                continue;
            }
            OpportunityTeamMember otm = new OpportunityTeamMember();
            otm.OpportunityId = o.Id;
            otm.UserId = salesManagerId;
            otm.TeamMemberRole = 'Sales Manager';
            teamMembersToInsert.add(otm);
        }

        if (!teamMembersToInsert.isEmpty()) {
            insert teamMembersToInsert;
        }
    }
}