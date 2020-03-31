global class Batch_OverdueTasks implements Database.Batchable<sObject>,Schedulable,Database.Stateful{
	public Set<Id> s_userIds;
	global Database.QueryLocator start(Database.BatchableContext BC){
		Integer LIMIT_INT = 100000000;
		s_userIds = new Set<Id>();
		Date batchDate = Date.Today().addDays(-2);
		if(Test.isRunningTest()) {
			LIMIT_INT = 1; 
			batchDate = Date.Today().AddDays(1);
		}
		return Database.getQueryLocator([SELECT Id,	OwnerId FROM Task WHERE Status != 'Completed' AND ActivityDate < :batchDate LIMIT : LIMIT_INT]);
	}

	global void execute(Database.BatchableContext BC, List<Task> scope){
		List<Task> l_tasks = scope;
		Schema.sObjectType userObjectType = Schema.User.SObjectType;
		for(Task item : l_tasks) {
			if (item.OwnerId.getSobjectType() == userObjectType) {
				s_userIds.add(item.OwnerId);
			}
		}
	}
	
	global void finish(Database.BatchableContext BC){	
		Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
		List<Id> l_userIds = new List<Id>(s_userIds);
		mail.setTargetObjectIds(l_userIds);
		mail.setSaveAsActivity(false);
		List<EmailTemplate> l_templates = [SELECT Id FROM EmailTemplate WHERE DeveloperName ='Overdue_Tasks'];
		if (l_templates.size() > 0) {
			mail.setTemplateID(l_templates[0].Id);
		}
		Messaging.sendEmail(new Messaging.MassEmailMessage[] {mail}); 
	}
	
	// The excuteBatch method for scheduleing
	global void execute(SchedulableContext SC){
		//Constructor
		Batch_OverdueTasks	batchJob = new Batch_OverdueTasks ();
		//Initiate the batch with batchsize 500
		ID batchprocessid = Database.executeBatch(batchJob,500);			 
	}
}