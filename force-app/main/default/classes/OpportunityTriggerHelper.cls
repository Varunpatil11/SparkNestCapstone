public with sharing class OpportunityTriggerHelper {

    /**
     * Fix for OpportunityTriggerHandlerFA dependency
     */
    public static void setClosedWonFields(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        // Preserves compilation for OpportunityTriggerHandlerFA
    }

    /**
     * Scenario 15: Track days spent in Negotiation/Review stage
     */
    public static void trackNegotiationStageDuration(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        for (Opportunity opp : newOpps) {
            Opportunity oldOpp = oldOppMap.get(opp.Id);

            // Stage changed
            if (opp.StageName != oldOpp.StageName) {
                // Entering Negotiation stage
                if (opp.StageName == 'Negotiation/Review') {
                    opp.Negotiation_Start_Date__c = Date.today();
                    opp.Negotiation_End_Date__c = null;
                }
                // Exiting Negotiation stage
                else if (oldOpp.StageName == 'Negotiation/Review' && opp.Negotiation_Start_Date__c != null) {
                    opp.Negotiation_End_Date__c = Date.today();
                    
                    Integer daysSpent = opp.Negotiation_Start_Date__c.daysBetween(opp.Negotiation_End_Date__c);
                    
                    Decimal currentTotal = opp.Days_in_Negotiation__c != null ? opp.Days_in_Negotiation__c : 0;
                    opp.Days_in_Negotiation__c = currentTotal + (daysSpent >= 0 ? daysSpent : 0);
                }
            }
        }
    }

    /**
     * Scenario 12: Count Open Opportunities on Account
     */
    public static void handleAfterInsert(List<Opportunity> newOpps) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : newOpps) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        updateAccountOpenOppCount(accountIds);
    }

    public static void handleAfterUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : newOpps) {
            Opportunity oldOpp = oldOppMap.get(opp.Id);
            if (opp.AccountId != oldOpp.AccountId) {
                if (opp.AccountId != null) accountIds.add(opp.AccountId);
                if (oldOpp.AccountId != null) accountIds.add(oldOpp.AccountId);
            } else if (opp.IsClosed != oldOpp.IsClosed && opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        updateAccountOpenOppCount(accountIds);
    }

    public static void handleAfterDelete(List<Opportunity> oldOpps) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : oldOpps) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        updateAccountOpenOppCount(accountIds);
    }

    public static void handleAfterUndelete(List<Opportunity> newOpps) {
        handleAfterInsert(newOpps);
    }

    private static void updateAccountOpenOppCount(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) return;

        Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
        for (Id accId : accountIds) {
            accountsToUpdate.put(accId, new Account(Id = accId, Total_Open_Opportunities__c = 0));
        }

        for (AggregateResult ar : [
            SELECT AccountId, COUNT(Id) totalOpen
            FROM Opportunity
            WHERE AccountId IN :accountIds AND IsClosed = FALSE
            GROUP BY AccountId
        ]) {
            Id accId = (Id) ar.get('AccountId');
            Integer count = (Integer) ar.get('totalOpen');
            if (accountsToUpdate.containsKey(accId)) {
                accountsToUpdate.get(accId).Total_Open_Opportunities__c = count;
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate.values();
        }
    }
}