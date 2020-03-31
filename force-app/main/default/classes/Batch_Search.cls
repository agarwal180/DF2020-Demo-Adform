global class Batch_Search implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    public String batchType = null;
    public Map<Id, Set<Id>> finalresults;
    public Map<Account, List<Account>> finalresultsAcc;
    public Map<Contact, List<Contact>> finalresultsCont;
    public Map<Lead, List<Lead>> finalresultsLead;
    global Database.QueryLocator start(Database.BatchableContext BC){
            return Database.getQueryLocator([SELECT Reminder_Emails__c, Reminder_Emails_CC__c  FROM Account ]); 
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        List<Account> l_accounts = ( List<Account>) scope;
        List<Contact> l_contacts = new List<Contact>();
        for(Account a: l_accounts) {
            if (a.Reminder_Emails__c != null) {
            List<String> l_emails = a.Reminder_Emails__c.split(';');
              for(String email : l_emails) {
                if (Utilities.validateEmail(email)){ 
                  l_contacts.add(new Contact(Email=email, FirstName ='Reminder', LastName = 'Email', Sales_Role__c='Reminder Email To', AccountId = a.Id));
                }
              }
            }
            if (a.Reminder_Emails_CC__c != null) {
            List<String> l_emails = a.Reminder_Emails_CC__c.split(';');
              for(String email : l_emails) {
              if (Utilities.validateEmail(email)){ 
                l_contacts.add(new Contact(Email=email, FirstName ='Reminder', LastName = 'Email', Sales_Role__c='Reminder Email CC', AccountId = a.Id));
                }
              }
            }
        }
        insert  l_contacts;
    }
    
    global void finish(Database.BatchableContext BC){  
        
    }
}