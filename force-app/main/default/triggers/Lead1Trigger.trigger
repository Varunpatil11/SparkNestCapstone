trigger Lead1Trigger on Lead (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        LeadTriggerHandler1.handleBeforeInsert(Trigger.new);
    }
}