public with sharing class LeadTriggerHelper {

    // Scenario 14: Prevent conversion if Phone is empty
    public static void validateLeadConversionPhone(List<Lead> newLeads, Map<Id, Lead> oldLeadMap) {
        for (Lead ld : newLeads) {
            Lead oldLead = oldLeadMap.get(ld.Id);
            
            // Check if record is transitioning to converted status
            if (ld.IsConverted && !oldLead.IsConverted) {
                if (String.isBlank(ld.Phone)) {
                    ld.Phone.addError('A Lead cannot be converted without a Phone number. Please enter a Phone number before converting.');
                }
            }
        }
    }

    // Scenario 13: Prevent duplicate email
    public static void checkDuplicateEmail(List<Lead> newLeads, Map<Id, Lead> oldLeadMap) {
        Set<String> emailsToCheck = new Set<String>();
        Set<String> seenBatchEmails = new Set<String>();

        for (Lead ld : newLeads) {
            if (String.isNotBlank(ld.Email)) {
                String lowerEmail = ld.Email.toLowerCase().trim();
                Boolean emailChanged = (oldLeadMap == null) || (ld.Email != oldLeadMap.get(ld.Id).Email);

                if (emailChanged) {
                    if (seenBatchEmails.contains(lowerEmail)) {
                        ld.Email.addError('A Lead with this email address already exists in TechVerse (duplicate in batch).');
                    } else {
                        seenBatchEmails.add(lowerEmail);
                        emailsToCheck.add(lowerEmail);
                    }
                }
            }
        }

        if (emailsToCheck.isEmpty()) {
            return;
        }

        Map<String, Id> existingEmailMap = new Map<String, Id>();
        for (Lead existingLead : [
            SELECT Id, Email 
            FROM Lead 
            WHERE Email IN :emailsToCheck
        ]) {
            if (String.isNotBlank(existingLead.Email)) {
                existingEmailMap.put(existingLead.Email.toLowerCase().trim(), existingLead.Id);
            }
        }

        for (Lead ld : newLeads) {
            if (String.isNotBlank(ld.Email)) {
                String lowerEmail = ld.Email.toLowerCase().trim();
                if (existingEmailMap.containsKey(lowerEmail)) {
                    if (oldLeadMap == null || existingEmailMap.get(lowerEmail) != ld.Id) {
                        ld.Email.addError('A Lead with this email address already exists in the system: ' + ld.Email);
                    }
                }
            }
        }
    }
}