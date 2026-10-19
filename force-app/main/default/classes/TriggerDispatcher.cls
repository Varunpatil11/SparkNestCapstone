public class TriggerDispatcher {
    public interface ITriggerHandler {
        void beforeInsert();
        void beforeUpdate();
        void afterInsert();
        void afterUpdate();
    }

    public static void run(ITriggerHandler handler) {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                handler.beforeInsert();
            } else if (Trigger.isUpdate) {
                handler.beforeUpdate();
            }
        } else if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                handler.afterInsert();
            } else if (Trigger.isUpdate) {
                handler.afterUpdate();
            }
        }
    }
}