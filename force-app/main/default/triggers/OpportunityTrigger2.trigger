trigger OpportunityTrigger2 on Opportunity (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandler2.handleAfterUpdate(Trigger.oldMap, Trigger.newMap);
    }
}