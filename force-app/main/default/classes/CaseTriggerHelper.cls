public class CaseTriggerHelper {
    public static void setEmailCaseDefaults(List<Case> newCases) {
        for (Case c : newCases) {
            if ('Email'.equals(c.Origin)) {
                c.Status = 'New';
                c.Priority = 'Normal';
            }
        }
    }
}