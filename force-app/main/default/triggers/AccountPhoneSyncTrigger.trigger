trigger AccountPhoneSyncTrigger on Account (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        AccountPhoneSyncHandler.handleAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }
}