public class OpportunityTriggerHelper1 {

    public static void addSalesManagerToHighValueOpps(List<Opportunity> newOpps) {

        List<Opportunity> qualifyingOpps = new List<Opportunity>();
        for (Opportunity o : newOpps) {
            if (o.Amount != null && o.Amount > 5000000) {
                qualifyingOpps.add(o);
            }
        }

        if (qualifyingOpps.isEmpty()) {
            return;
        }

        Opportunity_Team_Setting__mdt setting = Opportunity_Team_Setting__mdt.getInstance('Default');

        if (setting == null || String.isBlank(setting.Sales_Manager_Username__c)) {
            return;
        }

        List<User> salesManagers = [
            SELECT Id
            FROM User
            WHERE Username = :setting.Sales_Manager_Username__c
            LIMIT 1
        ];

        if (salesManagers.isEmpty()) {
            return;
        }

        Id salesManagerId = salesManagers[0].Id;

        List<OpportunityTeamMember> teamMembersToInsert = new List<OpportunityTeamMember>();
        for (Opportunity o : qualifyingOpps) {
            OpportunityTeamMember otm = new OpportunityTeamMember();
            otm.OpportunityId = o.Id;
            otm.UserId = salesManagerId;
            otm.TeamMemberRole = 'Sales Manager';
            teamMembersToInsert.add(otm);
        }

        insert teamMembersToInsert;
    }
}