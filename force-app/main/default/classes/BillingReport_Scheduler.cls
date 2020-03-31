global class BillingReport_Scheduler implements Schedulable{
    // The excuteBatch method for scheduleing
    global void execute(SchedulableContext SC){
        Date lastMonthFirstDay = Date.today().addMonths(-1);
        List<Account> l_accouns = [SELECT Name, BillingStreet, BillingPostalCode, BillingCity, BillingCountry,
                                   Relationship_Type__c, Customer_Group_Name__c,Account_Level__c,Parent.Name, Owner.Name,
                                   CurrencyIsoCode, VAT_Number__c, Registered_Number__c, Id, Notes__c, Invoice_Emails__c, 
                                     CreatedDate FROM Account WHERE LastModifiedDate >= LAST_MONTH];
        Map <String, Schema.SObjectField> m_accountFields  =  Account.sObjectType.getDescribe().fields.getMap();
        String header ='';
        List<String> l_headerValues = new List<String>{'Is New', 'Account Name',
                                                        'Invoice Street',
                                                        'Invoice Zip/Postal Code',
                                                        'Invoice city',
                                                        'Invoice country',
                                                        'Account Type',
                                                        'Customer Group Name',
                                                        'Account Level',
                                                        'Parent Account',
                                                        'Account owner',
                                                        'Account Currency',
                                                        'VAT Number / Sales Tax',
                                                        'Registered Number',
                                                        'Account ID',
                                                        'Notes & Attachments',
                                                        'Invoice Email'};
        
        header = String.join(l_headerValues, ',')+'\n';
        String finalstr = header;
        String recordString = '';
        for(Account a: l_accouns) {
            String fieldStr = '';
            List<object> l_fieldValues = new List<object>();
            
            String isNew = 'Updated';
            if (a.CreatedDate >= lastMonthFirstDay) {
                isNew = 'New';
            }
            l_fieldValues.add('"'+isNew+'"');
            l_fieldValues.add('"'+a.Name+'"');
            l_fieldValues.add('"'+(a.BillingStreet != null ? a.BillingStreet : '')+'"');
            l_fieldValues.add('"'+(a.BillingPostalCode != null ? a.BillingPostalCode : '')+'"');
            l_fieldValues.add('"'+(a.BillingCity != null ? a.BillingCity : '')+'"');
            l_fieldValues.add('"'+(a.BillingCountry != null ? a.BillingCountry : '')+'"');
            l_fieldValues.add('"'+(a.Relationship_Type__c != null ? a.Relationship_Type__c : '')+'"');
            l_fieldValues.add('"'+(a.Customer_Group_Name__c != null ? a.Customer_Group_Name__c : '')+'"');
            l_fieldValues.add('"'+(a.Account_Level__c != null ? a.Account_Level__c : '')+'"');
            l_fieldValues.add('"'+(a.Parent.Name != null ? a.Parent.Name : '')+'"');
            l_fieldValues.add('"'+(a.Owner.Name != null ? a.Owner.Name : '') +'"');
            l_fieldValues.add('"'+(a.CurrencyIsoCode != null ? a.CurrencyIsoCode : '')+'"');
            l_fieldValues.add('"'+(a.VAT_Number__c != null ? a.VAT_Number__c : '')+'"');
            l_fieldValues.add('"'+(a.Registered_Number__c != null ? a.Registered_Number__c : '')+'"');
            l_fieldValues.add('"'+a.Id+'"');
            l_fieldValues.add('"'+(a.Notes__c != null ? a.Notes__c : '')+'"');
            l_fieldValues.add('"'+(a.Invoice_Emails__c != null ? a.Invoice_Emails__c : '')+'"');
            recordString+=String.escapeSingleQuotes(String.join(l_fieldValues, ',')+'\n');
        }
        Datetime myDT = Datetime.now().addMonths(-1);
        String dateStr = myDT.format('MMMM YYYY');
        finalstr = finalstr+recordString;
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        string csvname= 'BillingReport'+dateStr+'.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        List<String> l_emails = new List<String>();
        Admin_Setting__c setting =  Admin_Setting__c.getOrgDefaults();
        if (setting != null && String.isNotBlank(setting.Billing_Emails__c)) {
            l_emails.addAll(setting.Billing_Emails__c.split(';'));
        }
        if (l_emails.size() == 0) {
            l_emails.add(UserInfo.getUserEmail());
        }
        String subject ='Billing Report '+dateStr;
        email.setSubject(subject);
        email.setToAddresses( l_emails );
        email.setPlainTextBody('Billing Report Results for '+dateStr);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}