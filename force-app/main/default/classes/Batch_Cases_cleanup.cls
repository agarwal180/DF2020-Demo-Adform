global class Batch_Cases_cleanup implements Database.Batchable<sObject>,Schedulable,Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Id recordTypeId = [SELECT ID FROM RecordType WHERE DeveloperName = 'Order_Contract'].Id;
        Integer LIMIT_INT = 100000000;
        Date batchDate = Date.Today().addDays(-7);
        if(Test.isRunningTest()) {
            LIMIT_INT = 1; 
        }
        
        return Database.getQueryLocator([SELECT ID FROM CASE WHERE RecordTypeId = : recordTypeId AND CreatedDate >:batchDate  LIMIT : LIMIT_INT]);
    }

    global void execute(Database.BatchableContext BC, List<Case> scope){
        List<Case> caseRecords = (List<Case>) scope;
        caseRecords = [SELECT ID, (SELECT ID FROM EmailMessages) FROM CASE WHERE ID IN : caseRecords];
        List<Case> caseToDelete = new List<Case>();
        for(Case item: caseRecords) {
            if(item.EmailMessages.size() == 0) {
                caseToDelete.add(item);
            }
        } 
        delete caseToDelete;
    }
    
    global void finish(Database.BatchableContext BC){  
        
    }
    
    // The excuteBatch method for scheduleing
    global void execute(SchedulableContext SC){
        //Constructor
        Batch_Cases_cleanup  batchJob = new Batch_Cases_cleanup ();
        //Initiate the batch with batchsize 500
        ID batchprocessid = Database.executeBatch(batchJob,500);           
    }
}