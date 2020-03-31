global class BillingIntegrationSyncFix_Batch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, Minimum_Fee_Period__c, LastModifiedDate FROM Contract WHERE Minimum_Fee_Period__c != null AND LastModifiedDate < 2019-09-14T00:00:00.000Z LIMIT 15';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        List<Contract> listToUpdate = new List<Contract>();
        for(Contract c : (List<Contract>) scope){
            listToUpdate.add(c);
        }
        update listToUpdate;
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}