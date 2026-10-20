trigger OpportunityTrigger on Opportunity (before update, after insert, after update, after delete, after undelete) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            OpportunityTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            OpportunityTriggerHandler.afterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            OpportunityTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
            OpportunityTriggerHandler.afterDelete(Trigger.old);
        } else if (Trigger.isUndelete) {
            OpportunityTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}