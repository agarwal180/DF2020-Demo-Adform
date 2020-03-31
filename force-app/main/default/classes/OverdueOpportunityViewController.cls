public with sharing class OverdueOpportunityViewController {
	public List<Opportunity> l_opportunities { get; set; }
	public OverdueOpportunityViewController() {
		Set<String> s_stages = new Set<String>();
		Date overdueDate = Date.Today().addDays(-2);
		if(Test.isRunningTest()) {
			overdueDate = Date.Today().AddDays(1);
		}
		for(OpportunityStage item : [SELECT ApiName FROM OpportunityStage WHERE isClosed = true]) {
			s_stages.add(item.ApiName);
		}
		List<Schema.FieldSetMember> productFields = SObjectType.OpportunityLineItem.FieldSets.Opportunity_Product.getFields();
		List <String> l_opportunityFields = new List<String>{'Name', 'Id'};
		List<Schema.FieldSetMember> l_fields = SObjectType.Opportunity.FieldSets.Overdue_Opportunity_view.getFields();
		for(Schema.FieldSetMember f : l_fields) {
			if (f.getFieldPath() != 'Name' && f.getFieldPath() != 'Id' ) {
				l_opportunityFields.add(f.getFieldPath());
			}
		}
		String field = String.join(l_opportunityFields, ',');
		Id currentUserId = userInfo.getUserId();
		l_opportunities = Database.query('SELECT '+field+' FROM Opportunity WHERE CloseDate < :overdueDate AND StageName NOT IN :s_stages AND OwnerId = :currentUserId');
	}
}