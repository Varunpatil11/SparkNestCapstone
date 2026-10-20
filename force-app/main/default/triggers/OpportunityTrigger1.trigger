trigger OpportunityTrigger1 on Opportunity (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        OpportunityTriggerHandler1.handleAfterInsert(Trigger.new);
    }
}