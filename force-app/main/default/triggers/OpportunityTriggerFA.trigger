trigger OpportunityTriggerFA on Opportunity (before update, after update) {

    if (Trigger.isBefore && Trigger.isUpdate) {
        OpportunityTriggerHandlerFA.beforeUpdate(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandlerFA.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}