public class CaseTriggerHandler {
    public static void handleBeforeInsert(List<Case> newCases) {
        CaseTriggerHelper.setEmailCaseDefaults(newCases);
    }
}