global with sharing class BillingIntegrationSyncFix_Schedule implements Schedulable {
    global void execute(SchedulableContext sc){
        Id BatchId = Database.executeBatch(new BillingIntegrationSyncFix_Batch());
    }
    
    public static void SchedulerMethod(){
        System.schedule('BillingIntegrationSyncFix_Batch-00', '0 0 * * * ?', new BillingIntegrationSyncFix_Schedule());
        System.schedule('BillingIntegrationSyncFix_Batch-15', '0 15 * * * ?', new BillingIntegrationSyncFix_Schedule());
        System.schedule('BillingIntegrationSyncFix_Batch-30', '0 30 * * * ?', new BillingIntegrationSyncFix_Schedule());
        System.schedule('BillingIntegrationSyncFix_Batch-45', '0 45 * * * ?', new BillingIntegrationSyncFix_Schedule());
    }
}