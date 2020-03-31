public with sharing class OpportunityProductsController {
    public List<OpportunityLineItem> products { get; set; }
    public Opportunity opportunityRecord { get; set; }
    public List<String> monthValues { get; set; }   
    public List<String> totalValue { get; set; }
    public Map<String, String> headerValues { get; set; }
    public Map<String, String> footerValues {get; set; }
    public CurrencyType defaultCurrencyType;
    public Map<String, CurrencyType> currencyMap;
    public Boolean isDealValueVisible { get; set; }
    public OpportunityProductsController(ApexPages.StandardController con){
        totalValue = new List<String>();
        headerValues = new Map<String,String>();
        footerValues = new Map<String, String>();
        if(!test.isRunningTest()) {
            con.addFields(new List<String>{'Start_From__c','CloseDate','CurrencyIsoCode'});
        }
        this.opportunityRecord = (Opportunity) con.getRecord();
        products = [SELECT X1_Month__c, Product2.Name,X2_Month__c, X3_Month__c, X4_Month__c,X5_Month__c,X6_Month__c,X7_Month__c,X8_Month__c,X9_Month__c,X10_Month__c,X11_Month__c,X12_Month__c,
             CurrencyIsoCode,Contract_Type__c,Guaranteed_Revenue__c,Guaranteed_Revenue_Percent__c,Guaranteed_Revenue_Total__c,Id,Incremental_Revenue_Percent__c,Incremental_Revenue_Total__c,
            ListPrice,Name,OpportunityId,PricebookEntryId,Product2Id,ProductCode,Product__c,Quantity,Terms__c,TotalPrice,UnitPrice FROM OpportunityLineItem WHERE OpportunityId =: opportunityRecord.Id order by X1_Month__c];
        monthValues = new List<String>();
        Integer startMonth = 0;
        if(opportunityRecord.Start_From__c == 'January') {
            startMonth = 1;
        }
        else if(opportunityRecord.Start_From__c == 'February') {
            startMonth = 2;
        }
        else if(opportunityRecord.Start_From__c == 'March') {
            startMonth = 3;
        }
        else if(opportunityRecord.Start_From__c == 'April') {
            startMonth = 4;
        }
        else if(opportunityRecord.Start_From__c == 'May') {
            startMonth = 5;
        }
        else if(opportunityRecord.Start_From__c == 'June') {
            startMonth = 6;
        }
        else if(opportunityRecord.Start_From__c == 'July') {
            startMonth = 7;
        }
        else if(opportunityRecord.Start_From__c == 'August') {
            startMonth = 8;
        }
        else if(opportunityRecord.Start_From__c == 'September') {
            startMonth = 9;
        }
        else if(opportunityRecord.Start_From__c == 'October') {
            startMonth = 10;
        }
        else if(opportunityRecord.Start_From__c == 'November') {
            startMonth = 11;
        }
        else if(opportunityRecord.Start_From__c == 'December') {
            startMonth = 12;
        }
        currencyMap = new Map<String, CurrencyType>();
        List<CurrencyType> currensyType = [SELECT ConversionRate,DecimalPlaces,IsActive,IsCorporate,IsoCode FROM CurrencyType WHERE IsActive = true];
        for(CurrencyType item : currensyType) {
            currencyMap.put(item.IsoCode, item);
            if(item.IsCorporate) {
                defaultCurrencyType = item;
            }
        }
        Datetime newTimeVariable = datetime.newInstance(opportunityRecord.CloseDate.year(), startMonth, 10);
        system.debug('newTimeVariable==='+newTimeVariable);
         system.debug('newTimeVariable==='+newTimeVariable.format('MMM (YY)'));
        monthValues.add(newTimeVariable.format('MMM (YY)'));
        for(integer i=1; i<12;i++) {
             system.debug('newTimeVariable==='+newTimeVariable.addmonths(i));
              system.debug('newTimeVariable==='+newTimeVariable.addmonths(i).format('MMM (YY)'));
            monthValues.add(newTimeVariable.addmonths(i).format('MMM (YY)'));
        }
        Decimal totalVal = 0;
        Decimal Total1 = 0;
        Decimal Total2 = 0;
        Decimal Total3 = 0;
        Decimal Total4 = 0;
        Decimal Total5 = 0;
        Decimal Total6 = 0;
        Decimal Total7 = 0;
        Decimal Total8 = 0;
        Decimal Total9 = 0;
        Decimal Total10 = 0;
        Decimal Total11 = 0;
        Decimal Total12 = 0;
        Decimal Guaranteed_Revenue = 0;
        for(OpportunityLineItem item : products) {
            totalVal = totalVal + ((item.UnitPrice != null) ? item.UnitPrice : 0 );
            Total1 = Total1 + ((item.X1_Month__c != null) ? item.X1_Month__c : 0 );
            Total2 = Total2 + ((item.X2_Month__c != null) ? item.X2_Month__c : 0 );
            Total3 = Total3 + ((item.X3_Month__c != null) ? item.X3_Month__c : 0 );
            Total4 = Total4 + ((item.X4_Month__c != null) ? item.X4_Month__c : 0 );
            Total5 = Total5 + ((item.X5_Month__c != null) ? item.X5_Month__c : 0 );
            Total6 = Total6 + ((item.X6_Month__c != null) ? item.X6_Month__c : 0 );
            Total7 = Total7 + ((item.X7_Month__c != null) ? item.X7_Month__c : 0 );
            Total8 = Total8 + ((item.X8_Month__c != null) ? item.X8_Month__c : 0 );
            Total9 = Total9 + ((item.X9_Month__c != null) ? item.X9_Month__c : 0 );
            Total10 = Total10 + ((item.X10_Month__c != null) ? item.X10_Month__c : 0 );
            Total11 = Total11 + ((item.X11_Month__c != null) ? item.X11_Month__c : 0 );
            Total12 = Total12 + ((item.X12_Month__c != null) ? item.X12_Month__c : 0 );
            Guaranteed_Revenue = Guaranteed_Revenue + ((item.Guaranteed_Revenue__c != null) ? item.Guaranteed_Revenue__c : 0 );
        }
        List<Schema.FieldSetMember> productFields = SObjectType.OpportunityLineItem.FieldSets.Opportunity_Product.getFields();
        Map<String, Schema.SObjectField> FsMap = OpportunityLineItem.sObjectType.getDescribe().fields.getMap();
        for(Schema.FieldSetMember f : productFields) {
            if(f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.UnitPrice.getName()) {
                headerValues.put(f.getFieldPath(),Label.Deal_Value);
                footerValues.put(f.getFieldPath(), prepareTotalValue(totalVal));
            }
            else if (f.getFieldPath() ==Schema.SObjectType.OpportunityLineItem.fields.X1_Month__c.getName()) {
                headerValues.put(f.getFieldPath(),monthValues[0]);
                footerValues.put(f.getFieldPath(), prepareTotalValue(Total1));
            }
            else if (f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.X2_Month__c.getName()) {
                headerValues.put(f.getFieldPath(),monthValues[1]);
                footerValues.put(f.getFieldPath(), prepareTotalValue(Total2));
            }
            else if (f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.X3_Month__c.getName()) {
                headerValues.put(f.getFieldPath(),monthValues[2]);
                footerValues.put(f.getFieldPath(),prepareTotalValue(Total3));
            }
            else if (f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.X4_Month__c.getName()) {
                headerValues.put(f.getFieldPath(),monthValues[3]);
                footerValues.put(f.getFieldPath(),prepareTotalValue(Total4));
            }
            else if (f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.X5_Month__c.getName()) {
                headerValues.put(f.getFieldPath(),monthValues[4]);
                footerValues.put(f.getFieldPath(),prepareTotalValue(Total5));
            }
            else if (f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.X6_Month__c.getName()) {
                headerValues.put(f.getFieldPath(),monthValues[5]);
                footerValues.put(f.getFieldPath(),prepareTotalValue(Total6));
            }
            else if (f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.X7_Month__c.getName()) {
                headerValues.put(f.getFieldPath(),monthValues[6]);
                footerValues.put(f.getFieldPath(),prepareTotalValue(Total7));
            }
            else if (f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.X8_Month__c.getName()) {
                headerValues.put(f.getFieldPath(),monthValues[7]);
                footerValues.put(f.getFieldPath(),prepareTotalValue(Total8));
            }
            else if (f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.X9_Month__c.getName()) {
                headerValues.put(f.getFieldPath(),monthValues[8]);
                footerValues.put(f.getFieldPath(),prepareTotalValue(Total9));
            }
            else if (f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.X10_Month__c.getName()) {
                headerValues.put(f.getFieldPath(),monthValues[9]);
                footerValues.put(f.getFieldPath(),prepareTotalValue(Total10));
            }
            else if (f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.X11_Month__c.getName()) {
                headerValues.put(f.getFieldPath(),monthValues[10]);
                footerValues.put(f.getFieldPath(),prepareTotalValue(Total11));
            }
            else if (f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.X12_Month__c.getName()) {
                headerValues.put(f.getFieldPath(),monthValues[11]);
                footerValues.put(f.getFieldPath(),prepareTotalValue(Total12));
            }
            else if (f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.Product2Id.getName()) {
                headerValues.put(f.getFieldPath(), Product2.sObjectType.getDescribe().getLabel());
                footerValues.put(f.getFieldPath(),'');
            }
            else if (f.getFieldPath() == Schema.SObjectType.OpportunityLineItem.fields.Guaranteed_Revenue__c.getName()) {
                headerValues.put(f.getFieldPath(), FsMap.get(f.getFieldPath()).getDescribe().getLabel());
                footerValues.put(f.getFieldPath(),prepareTotalValue(Guaranteed_Revenue));
            }
            else {
                headerValues.put(f.getFieldPath(), FsMap.get(f.getFieldPath()).getDescribe().getLabel());
                footerValues.put(f.getFieldPath(),'');
            }
            
        }
        
        User loggedInUser = [SELECT Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];
        List<Opportunity> l_opp = [SELECT Owner.Id FROM Opportunity WHERE Id = :opportunityRecord.Id LIMIT 1];
        User recordOwner;
        for(Opportunity opp : l_opp){
            recordOwner = [SELECT UserRoleId FROM User WHERE Id = :opp.OwnerId];
        }
        List<String> l_recSupportedRoles = getRecordSupportedRoles(recordOwner);
        System.debug(l_recSupportedRoles);
        if(recordOwner != null && (l_recSupportedRoles.contains(loggedInUser.UserRoleId) || recordOwner.Id == loggedInUser.Id)){
            this.isDealValueVisible = true;
        } else if(recordOwner == null){
            this.isDealValueVisible = true;
        } else {
            this.isDealValueVisible = false;
        }
    }
    
    public String prepareTotalValue(Decimal totalValue){
        String strTotal = this.opportunityRecord.CurrencyIsoCode+' '+totalValue.format();
        CurrencyType currencyRec = currencyMap.get(this.opportunityRecord.CurrencyIsoCode);
        if(currencyRec != null && currencyRec.IsCorporate == false) {
            Decimal defaultTotal = totalValue/currencyRec.ConversionRate;
            strTotal += ' ('+defaultCurrencyType.IsoCode+' '+defaultTotal.setscale(2).format()+')';
        }
        return strTotal;
    }
    
    public List<String> getRecordSupportedRoles(User recordOwner){
        List<String> l_visibleForRoles = new List<String>();
        if(recordOwner != null){
            UserRole ownerRole;
            ownerRole = [SELECT Id, ParentRoleId FROM UserRole WHERE Id = :recordOwner.UserRoleId];
            String parentRoleId = ownerRole.ParentRoleId;
            UserRole parentRole;
            while(parentRoleId != null){
                parentRole = [SELECT Id, ParentRoleId FROM UserRole WHERE Id = :parentRoleId];
                l_visibleForRoles.add(parentRole.Id);
                parentRoleId = parentRole.ParentRoleId;
            }
        }
        return l_visibleForRoles;
    }
}