public class CloseStaleEnquiriesScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        CloseStaleEnquiriesBatch batchJob = new CloseStaleEnquiriesBatch();
        Database.executeBatch(batchJob, 200);
    }
}