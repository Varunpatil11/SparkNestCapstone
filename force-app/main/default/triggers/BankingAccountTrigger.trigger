trigger BankingAccountTrigger on Account (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        BankingAccountHandler.handleAfterInsert(Trigger.new);
    }
}