@RestResource(urlMapping='/SparkNestEnquiry/*')
global with sharing class SparkNestEnquiryAPI {

    global class EnquiryRequestWrapper {
        public String firstName;
        public String lastName;
        public String email;
        public String phone;
        public String subject;
        public String enquiryType;
        public String priority;
        public Decimal customerBudget;
    }

    global class EnquiryResponseWrapper {
        public Boolean success;
        public String message;
        public Id contactId;
        public Id enquiryId;

        public EnquiryResponseWrapper(Boolean success, String message, Id contactId, Id enquiryId) {
            this.success = success;
            this.message = message;
            this.contactId = contactId;
            this.enquiryId = enquiryId;
        }
    }

    @HttpPost
    global static EnquiryResponseWrapper createEnquiry(EnquiryRequestWrapper enquiryData) {
        RestResponse res = RestContext.response;

        // Validation: Missing Email Scenario (HTTP 400)
        if (enquiryData == null || String.isBlank(enquiryData.email)) {
            res.statusCode = 400;
            return new EnquiryResponseWrapper(false, 'Email is required to submit an enquiry.', null, null);
        }

        try {
            // Find Existing Contact by Email or Create New
            List<Contact> existingContacts = [
                SELECT Id, FirstName, LastName, Email 
                FROM Contact 
                WHERE Email = :enquiryData.email 
                LIMIT 1
            ];

            Contact customerContact;
            if (!existingContacts.isEmpty()) {
                customerContact = existingContacts[0];
            } else {
                customerContact = new Contact(
                    FirstName = enquiryData.firstName,
                    LastName = String.isNotBlank(enquiryData.lastName) ? enquiryData.lastName : 'Valued Customer',
                    Email = enquiryData.email,
                    Phone = enquiryData.phone
                );
                insert customerContact;
            }

            // Create Linked Enquiry Record
            Enquiry__c newEnquiry = new Enquiry__c(
                Subject__c = String.isNotBlank(enquiryData.subject) ? enquiryData.subject : 'Website Form Submission',
                Contact__c = customerContact.Id,
                Enquiry_Type__c = String.isNotBlank(enquiryData.enquiryType) ? enquiryData.enquiryType : 'Product Enquiry',
                Priority__c = String.isNotBlank(enquiryData.priority) ? enquiryData.priority : 'Medium',
                Status__c = 'New'
            );

            if (enquiryData.customerBudget != null) {
                newEnquiry.Customer_Budget__c = enquiryData.customerBudget;
            }

            insert newEnquiry;

            res.statusCode = 201;
            return new EnquiryResponseWrapper(true, 'Enquiry submitted successfully.', customerContact.Id, newEnquiry.Id);

        } catch (Exception ex) {
            res.statusCode = 500;
            return new EnquiryResponseWrapper(false, ex.getMessage(), null, null);
        }
    }
}