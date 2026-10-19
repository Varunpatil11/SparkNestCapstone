@isTest
public class TestDataFactory {
    
    // Helper to create a test Contact (required parent for Enquiry__c)
    public static Contact createTestContact(String lastName, Boolean doInsert) {
        Contact con = new Contact(
            LastName = lastName,
            Email = 'test.' + lastName.toLowerCase().replace(' ', '') + '@example.com'
        );
        if (doInsert) {
            insert con;
        }
        return con;
    }
    
    // Create single test Enquiry with required Contact
    public static Enquiry__c createEnquiry(String subject, String priority, Boolean doInsert) {
        Contact testCon = createTestContact('Customer', true);
        
        Enquiry__c enq = new Enquiry__c();
        enq.Subject__c = subject;
        enq.Priority__c = priority;
        enq.Status__c = 'New';
        enq.Contact__c = testCon.Id;
        
        if (doInsert) {
            insert enq;
        }
        return enq;
    }
    
    // Create a list of bulk Enquiries with required Contact
    public static List<Enquiry__c> createBulkEnquiries(Integer count, Boolean doInsert) {
        Contact testCon = createTestContact('BulkCustomer', true);
        
        List<Enquiry__c> enqList = new List<Enquiry__c>();
        for (Integer i = 0; i < count; i++) {
            Enquiry__c enq = new Enquiry__c();
            enq.Subject__c = 'Bulk Enquiry ' + i;
            enq.Priority__c = (Math.mod(i, 2) == 0) ? 'High' : 'Medium';
            enq.Status__c = 'New';
            enq.Contact__c = testCon.Id;
            enqList.add(enq);
        }
        if (doInsert) {
            insert enqList;
        }
        return enqList;
    }
}