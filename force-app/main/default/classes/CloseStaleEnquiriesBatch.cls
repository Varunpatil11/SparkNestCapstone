public class CloseStaleEnquiriesBatch implements Database.Batchable<sObject>, Database.Stateful {

    public Integer recordsProcessed = 0;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        DateTime thirtyDaysAgo = System.now().addDays(-30);
        return Database.getQueryLocator([
            SELECT Id, Status__c, CreatedDate 
            FROM Enquiry__c 
            WHERE Status__c != 'Closed' 
              AND CreatedDate <= :thirtyDaysAgo
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Enquiry__c> scope) {
        for (Enquiry__c enq : scope) {
            enq.Status__c = 'Closed';
            recordsProcessed++;
        }
        if (!scope.isEmpty()) {
            update scope;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('CloseStaleEnquiriesBatch completed. Total processed: ' + recordsProcessed);
    }
}