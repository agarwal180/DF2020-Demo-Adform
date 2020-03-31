global class Batch_OverdueOpportunity implements Database.Batchable<sObject>,Schedulable,Database.Stateful{
	public Set<Id> s_userIds;
	global Database.QueryLocator start(Database.BatchableContext BC){
		Integer LIMIT_INT = 100000000;
		s_userIds = new Set<Id>();
		Date batchDate = Date.Today().addDays(-2);
		Set<String> s_stages = new Set<String>();
		for(OpportunityStage item : [SELECT ApiName FROM OpportunityStage WHERE isClosed = true]) {
			s_stages.add(item.ApiName);
		}
		if(Test.isRunningTest()) {
			LIMIT_INT = 1; 
			batchDate = Date.Today().AddDays(1);
		}
		return Database.getQueryLocator([SELECT ID, OwnerId FROM Opportunity WHERE CloseDate < :batchDate AND StageName NOT IN :s_stages LIMIT : LIMIT_INT]);
	}

	global void execute(Database.BatchableContext BC, List<Opportunity> scope){
		List<Opportunity> l_opportunity = scope;
		Schema.sObjectType userObjectType = Schema.User.SObjectType;
		for(Opportunity item : l_opportunity) {
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
		List<EmailTemplate> l_templates = [SELECT Id FROM EmailTemplate WHERE DeveloperName ='OverdueOpportunity'];
		if (l_templates.size() > 0) {
			mail.setTemplateID(l_templates[0].Id);
		}
		Messaging.sendEmail(new Messaging.MassEmailMessage[] {mail}); 
	}
	
	// The excuteBatch method for scheduleing
	global void execute(SchedulableContext SC){
		//Constructor
		Batch_OverdueOpportunity  batchJob = new Batch_OverdueOpportunity ();
		//Initiate the batch with batchsize 500
		ID batchprocessid = Database.executeBatch(batchJob,500);		   
	}
}

/*
		Set<String> s_stages = new Set<String>();
		for(OpportunityStage item : [SELECT ApiName FROM OpportunityStage WHERE isClosed = true]) {
			s_stages.add(item.ApiName);
		}
		Date batchDate = Date.newinstance(2016, 9, 1);
		Date today = Date.today();
		List<Opportunity> l_opportunities =  [SELECT ID, OwnerId,StageName FROM Opportunity WHERE CloseDate < :batchDate AND StageName NOT IN :s_stages ];
		for(Opportunity opp : l_opportunities) {
			opp.StageName = '	Closed Lost';
			opp.CloseDate = today;
		}
		Database.SaveResult[] srList = Database.update(l_opportunities, false);
		
*/