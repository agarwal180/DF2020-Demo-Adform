public with sharing class EmailMessageTriggerHandler
{
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public EmailMessageTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(EmailMessage[] newEmails) {
        // used to update to SuppliedEmail
        Map<Id, EmailMessage> m_caseIdToEmail = new Map<Id, EmailMessage>();
        Map<String, EmailMessage> m_caseToEmail = new Map<String, EmailMessage>();
        for (EmailMessage em : newEmails) {
            if (em.ParentId != null) {
                if (em.Incoming == false) {
                    m_caseIdToEmail.put(em.ParentId, em);
                    system.debug('RECORD ID ---'+em.ParentId);
                }
            }
            system.debug('em.Incoming==='+em.Incoming);
            if (em.Incoming == true) {
				Pattern p = Pattern.compile('Order -\\s(\\d+)\\s?');
				Matcher m = p.matcher(em.Subject);
				system.debug('match==='+m);
				if (m.find()) {
				    String caseNumber = m.group(1).trim();
				    system.debug('match==='+caseNumber);
				    m_caseToEmail.put(caseNumber, em);
				}
            }
        }
        
        
        if (m_caseIdToEmail.size() > 0) {
	        List<Case> l_cases = [SELECT Id, RecordTypeId, Status, Origin,
	                            Description, 
	                            SuppliedEmail,  (SELECT Id from EmailMessages LIMIT 2)
	                            FROM Case
	                            WHERE ID IN :m_caseIdToEmail.keySet()];
	        List<Case> l_caseForUpdate = new List<Case>();
	        for(Case case_item : l_cases) {
	            if(case_item.EmailMessages.size() == 0) {
	                EmailMessage email = m_caseIdToEmail.get(case_item.Id);
	                if(email != null) {
	                    case_item.SuppliedEmail = email.ToAddress;
	                    case_item.Subject = email.Subject;
	                    case_item.Description = email.TextBody;
	                    l_caseForUpdate.add(case_item);
	                }
	            }
	        }
	        update l_caseForUpdate;
        }
        if (m_caseToEmail.size() > 0) {
            Map<String, Case> m_numberToCase = new Map<String, Case>();
            for(Case item : [SELECT Id, CaseNumber FROM Case WHERE CaseNumber IN :m_caseToEmail.keySet()]) {
                m_numberToCase.put(item.CaseNumber, item);
            }
            for (EmailMessage em : newEmails) {
	            if (em.Incoming == true) {
	                Pattern p = Pattern.compile('Order -\\s(\\d+)\\s?');
	                Matcher m = p.matcher(em.Subject);
	                if (m.find()) {
	                    String caseNumber = m.group(1).trim();
	                    Case tempCase = m_numberToCase.get(caseNumber);
	                    system.debug('caseNumber == '+caseNumber);
	                    system.debug('caseNumber == '+em.ParentId);
	                    if (tempCase != null && tempCase.Id != em.ParentId) {
		                    em.ParentId = tempCase.Id;
		                }
	                }
	            }
	        }
        }
    }

    public boolean IsTriggerContext { get { return m_isExecuting; } }
    public boolean IsVisualforcePageContext { get { return !IsTriggerContext; } }
    public boolean IsWebServiceContext { get { return !IsTriggerContext; } }
    public boolean IsExecuteAnonymousContext { get { return !IsTriggerContext; } }
}