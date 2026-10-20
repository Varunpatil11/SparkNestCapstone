@isTest
private class LeadTriggerTest {

    @isTest
    static void testWebLeadIsCold() {
        // Arrange
        Lead webLead = new Lead(
            LastName = 'Test Web',
            Company = 'Test Co',
            LeadSource = 'Web'
        );

        // Act
        Test.startTest();
        insert webLead;
        Test.stopTest();

        // Assert
        Lead result = [SELECT Rating FROM Lead WHERE Id = :webLead.Id];
        System.assertEquals('Cold', result.Rating, 'Web lead should be rated Cold');
    }

    @isTest
    static void testNonWebLeadIsHot() {
        // Arrange
        Lead phoneLead = new Lead(
            LastName = 'Test Phone',
            Company = 'Test Co',
            LeadSource = 'Phone Inquiry'
        );

        // Act
        Test.startTest();
        insert phoneLead;
        Test.stopTest();

        // Assert
        Lead result = [SELECT Rating FROM Lead WHERE Id = :phoneLead.Id];
        System.assertEquals('Hot', result.Rating, 'Non-Web lead should be rated Hot');
    }

    @isTest
    static void testBulkInsert() {
        // Arrange - test with multiple records (bulk safety)
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leads.add(new Lead(
                LastName = 'Bulk Test ' + i,
                Company = 'Test Co',
                LeadSource = (Math.mod(i, 2) == 0) ? 'Web' : 'Phone Inquiry'
            ));
        }

        // Act
        Test.startTest();
        insert leads;
        Test.stopTest();

        // Assert - spot check a few
        List<Lead> results = [SELECT LeadSource, Rating FROM Lead WHERE Id IN :leads];
        for (Lead l : results) {
            if (l.LeadSource == 'Web') {
                System.assertEquals('Cold', l.Rating);
            } else {
                System.assertEquals('Hot', l.Rating);
            }
        }
    }
}