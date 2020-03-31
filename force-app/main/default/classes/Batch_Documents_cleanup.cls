/*
Batch_Documents_cleanup m = new Batch_Documents_cleanup();
String sch = '0 0 3 * * ?';
system.schedule('Cleanup Users Documents', sch, m);
unit-test in the Batch_TESTs class 
*/
global class Batch_Documents_cleanup implements Database.Batchable<sObject>,Schedulable,Database.Stateful{

    global Database.QueryLocator start(Database.BatchableContext BC){
        String documentName = '%(IO Contract)%';
        Integer LIMIT_INT = 100000000;
        Date batchDate = Date.Today().addDays(-7);
        if(Test.isRunningTest()) {
            LIMIT_INT = 1; 
        }
        return Database.getQueryLocator([SELECT Id FROM Document WHERE Name LIKE :documentName AND CreatedDate > :batchDate]);
    }

    global void execute(Database.BatchableContext BC, List<Document> scope){
        list<Document> listDocuments2Delete = (List<Document>)scope;
        delete listDocuments2Delete;
    }
    
    global void finish(Database.BatchableContext BC){  
        
    }
    
    // The excuteBatch method for scheduleing
    global void execute(SchedulableContext SC){
        //Constructor
        Batch_Documents_cleanup  batchJob = new Batch_Documents_cleanup ();
        //Initiate the batch with batchsize 500
        ID batchprocessid = Database.executeBatch(batchJob,500);           
    }
}