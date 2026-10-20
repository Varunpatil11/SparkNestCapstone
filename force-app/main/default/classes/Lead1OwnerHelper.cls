public class Lead1OwnerHelper {

    public static void assignWebLeadsToSalesUser(List<Lead> newLeads) {

        Boolean hasWebLead = false;
        for (Lead l : newLeads) {
            if ('Web'.equals(l.LeadSource)) {
                hasWebLead = true;
                break;
            }
        }

        if (!hasWebLead) {
            return;
        }

        List<User> salesUsers = [
            SELECT Id
            FROM User
            WHERE Username = 'snehanair@sparknest.trailhead'
            LIMIT 1
        ];

        if (salesUsers.isEmpty()) {
            return;
        }

        Id salesUserId = salesUsers[0].Id;

        for (Lead l : newLeads) {
            if ('Web'.equals(l.LeadSource)) {
                l.OwnerId = salesUserId;
            }
        }
    }
}