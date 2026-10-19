public without sharing class EnquiryProductCountService {

    public static void recalculate(List<Enquiry_Product__c> newList, List<Enquiry_Product__c> oldList) {
        Set<Id> enquiryIds = new Set<Id>();

        if (newList != null) {
            for (Enquiry_Product__c ep : newList) {
                if (ep.Enquiry__c != null) {
                    enquiryIds.add(ep.Enquiry__c);
                }
            }
        }
        if (oldList != null) {
            for (Enquiry_Product__c ep : oldList) {
                if (ep.Enquiry__c != null) {
                    enquiryIds.add(ep.Enquiry__c);
                }
            }
        }
        if (enquiryIds.isEmpty()) {
            return;
        }

        Map<Id, Integer> counts = new Map<Id, Integer>();
        for (Id enquiryId : enquiryIds) {
            counts.put(enquiryId, 0);
        }

        for (AggregateResult ar : [
            SELECT Enquiry__c eid, COUNT(Id) total
            FROM Enquiry_Product__c
            WHERE Enquiry__c IN :enquiryIds
            GROUP BY Enquiry__c
        ]) {
            counts.put((Id) ar.get('eid'), (Integer) ar.get('total'));
        }

        List<Enquiry__c> toUpdate = new List<Enquiry__c>();
        for (Id enquiryId : counts.keySet()) {
            toUpdate.add(new Enquiry__c(
                Id = enquiryId,
                Total_Products_Interested__c = counts.get(enquiryId)
            ));
        }
        update toUpdate;
    }
}