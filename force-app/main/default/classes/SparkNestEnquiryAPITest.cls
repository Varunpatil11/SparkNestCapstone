@isTest
private class SparkNestEnquiryAPITest {

    @isTest
    static void testNewCustomerEnquiry() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SparkNestEnquiry';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        SparkNestEnquiryAPI.EnquiryRequestWrapper body = new SparkNestEnquiryAPI.EnquiryRequestWrapper();
        body.firstName = 'Aditi';
        body.lastName = 'Sharma';
        body.email = 'aditi.sharma@example.com';
        body.phone = '9876543210';
        body.subject = 'Solar Panel Specs';
        body.enquiryType = 'Product Enquiry';
        body.priority = 'Medium';
        body.customerBudget = 5000;

        Test.startTest();
        SparkNestEnquiryAPI.EnquiryResponseWrapper resp = SparkNestEnquiryAPI.createEnquiry(body);
        Test.stopTest();

        System.assertEquals(201, res.statusCode, 'Status code should be 201');
        System.assertEquals(true, resp.success, 'Request should succeed');
        System.assertNotEquals(null, resp.contactId, 'Contact Id should be generated');
        System.assertNotEquals(null, resp.enquiryId, 'Enquiry Id should be generated');
    }

    @isTest
    static void testExistingCustomerEnquiry() {
        Contact existing = TestDataFactory.createTestContact('Verma', true);
        existing.Email = 'verma.test@example.com';
        update existing;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        SparkNestEnquiryAPI.EnquiryRequestWrapper body = new SparkNestEnquiryAPI.EnquiryRequestWrapper();
        body.lastName = 'Verma';
        body.email = 'verma.test@example.com';
        body.subject = 'Existing Client Upgrade';

        Test.startTest();
        SparkNestEnquiryAPI.EnquiryResponseWrapper resp = SparkNestEnquiryAPI.createEnquiry(body);
        Test.stopTest();

        System.assertEquals(201, res.statusCode, 'Status code should be 201');
        System.assertEquals(existing.Id, resp.contactId, 'Should link to the existing Contact');
    }

    @isTest
    static void testMissingEmailThrows400() {
        RestResponse res = new RestResponse();
        RestContext.response = res;

        SparkNestEnquiryAPI.EnquiryRequestWrapper body = new SparkNestEnquiryAPI.EnquiryRequestWrapper();
        body.lastName = 'Unknown';
        body.email = null;

        Test.startTest();
        SparkNestEnquiryAPI.EnquiryResponseWrapper resp = SparkNestEnquiryAPI.createEnquiry(body);
        Test.stopTest();

        System.assertEquals(400, res.statusCode, 'Status code should be 400');
        System.assertEquals(false, resp.success, 'Success flag should be false');
    }
}