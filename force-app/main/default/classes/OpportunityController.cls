public with sharing class OpportunityController {
    public List<OpportunityStage> stageProbability { get; set; }
    public List<Schema.FieldSetMember> oppFields { get; set; }
    public List<OpportunityLineItem> products { get; set; }
    public Opportunity opportunityRecord { get; set; }
    public List<SelectOption> availabelProducts { get; set;}
    public boolean isShowOpportuntiy { get; set; }
    public List<Id> pricebookIds ;
    public List<String> productNames;
    public List<OpportunityLineItem> productsTodelete;
    public Boolean isRecordTypeSelection { get; set; }
    public Id SelectedRecordType { get; set; }
    public class RecordTypeItem {
        public String RecordTypeGroup { get; set; }
        public RecordType R_Type { get; set; }
        public Integer rowspan { get; set;}
    }
    public List<recordTypeItem> recordTypesToDisplay { get; set; }
    public List<SelectOption> recordTypes { get; set; }
    public Boolean isCloneAction;
    public Boolean isDealValueVisible { get; set; }
    public OpportunityController(ApexPages.StandardController con){
        productsTodelete = new List<OpportunityLineItem>();
        pricebookIds = new List<Id>();
        productNames = new List<String>();
        products = new List<OpportunityLineItem>();
        string isProductEdit = ApexPages.currentPage().getParameters().get('isProductEdit');
        String cLoneStr = ApexPages.currentPage().getParameters().get('clone');
        isShowOpportuntiy = true;
        prepareRecordTypes();
        isCloneAction = false;
        //con.addFields(new List<String>{'Action_Plan5lines__c','CurrencyIsoCode', 'RecordTypeId'});
        if(isProductEdit == 'true') {
            if(!test.isRunningTest()) {
                con.addFields(new List<String>{'CurrencyIsoCode', 'RecordTypeId','Pricebook2Id'});
            }
        }
        else if(cLoneStr == '1') {
            isCloneAction = true;
            Map<String, Schema.SObjectField> fieldsDescribe = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap();
            
            List<String> listValues = new List<String>{'CurrencyIsoCode', 'RecordTypeId'};
            for(Schema.SObjectField field : fieldsDescribe.values()) {
                listValues.add(field.getDescribe().getName());
            }
            if(!test.isRunningTest()) {
                con.addFields(listValues);
            }
        }
        this.opportunityRecord = (Opportunity) con.getRecord();
        availabelProducts = new  List<SelectOption> ();
        if(isProductEdit == 'true' || isCloneAction) {
            isRecordTypeSelection = false;
            SelectedRecordType = this.opportunityRecord.RecordTypeId;
            isShowOpportuntiy = false;
            products = [SELECT X1_Month__c, X2_Month__c, X3_Month__c, X4_Month__c,X5_Month__c,X6_Month__c,X7_Month__c,X8_Month__c,X9_Month__c,X10_Month__c,X11_Month__c,X12_Month__c,
             CurrencyIsoCode,Contract_Type__c,Guaranteed_Revenue__c,Guaranteed_Revenue_Percent__c,Guaranteed_Revenue_Total__c,Id,Incremental_Revenue_Percent__c,Incremental_Revenue_Total__c,
            ListPrice,Name,OpportunityId,PricebookEntryId,Product2Id,ProductCode,Product__c,Quantity,Terms__c,UnitPrice FROM OpportunityLineItem WHERE OpportunityId =: opportunityRecord.Id ];
            if(isCloneAction) {
                prepareDataAfterselection();
            }
            else {
                prepareREcordTypeInfo();
            }
            availabelProducts = prepareAvailabelProducts();
        }
        else {
            isRecordTypeSelection = true;
            /*Map<String, Schema.SObjectField> oppFieldsMap = Schema.SObjectType.Opportunity.fields.getMap();
            for(String item : oppFieldsMap.keyset()) {
                system.debug('field : '+item);
                system.debug('item : '+oppFieldsMap.get(item).getDescribe().getDefaultValue());
                if(oppFieldsMap.get(item).getDescribe().getDefaultValue() != null) {
                    this.opportunityRecord.put(item, oppFieldsMap.get(item).getDescribe().getDefaultValue());
                }
                if(oppFieldsMap.get(item).getDescribe().getDefaultValueFormula() != null) {
                    this.opportunityRecord.put(item, oppFieldsMap.get(item).getDescribe().getDefaultValueFormula());
                }
                
            }*/
        }
        
        if(isCloneAction) {
            isShowOpportuntiy = true;
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
        } else if (recordOwner == null){
            this.isDealValueVisible = true;
        } else {
            this.isDealValueVisible = false;
        }
    }
    public void prepareREcordTypeInfo () {
        RecordType recordTypeItem = [SELECT DeveloperName FROM RecordType WHERE Id=: this.opportunityRecord.RecordTypeId];
        List<Opportunity_Setting__c> settings = [SELECT ID,Field_Set_Name__c, Price_Book_Ids__c,Product_Names_For_Old_logic__c, Record_Type_Name__c FROM Opportunity_Setting__c WHERE Record_Type_Name__c =: recordTypeItem.DeveloperName];
        if(settings.size() > 0){
            Opportunity_Setting__c tempSetting = settings[0];
            if(tempSetting.Price_Book_Ids__c != null && tempSetting.Price_Book_Ids__c != '') {
                List<String> items = tempSetting.Price_Book_Ids__c.split(';');
                for(String item : items) {
                    pricebookIds.add(item);
                }
                
            }
            if(tempSetting.Product_Names_For_Old_logic__c != null && tempSetting.Product_Names_For_Old_logic__c != '') {
                List<String> items = tempSetting.Product_Names_For_Old_logic__c.split(',');
                for(String item : items) {
                    productNames.add(item);
                }
            }
        }
    }
    public void prepareDataAfterselection() {
        isRecordTypeSelection = false;
        this.opportunityRecord.RecordTypeId = SelectedRecordType;
        RecordType recordTypeItem = [SELECT DeveloperName FROM RecordType WHERE Id=: this.opportunityRecord.RecordTypeId];
        List<Opportunity_Setting__c> settings = [SELECT ID,Field_Set_Name__c, Price_Book_Ids__c,Product_Names_For_Old_logic__c, Record_Type_Name__c FROM Opportunity_Setting__c WHERE Record_Type_Name__c =: recordTypeItem.DeveloperName];
        String fieldsetName = null;
        if(settings.size() > 0){
            Opportunity_Setting__c tempSetting = settings[0];
            fieldsetName = tempSetting.Field_Set_Name__c;
            if(tempSetting.Price_Book_Ids__c != null && tempSetting.Price_Book_Ids__c != '') {
                List<String> items = tempSetting.Price_Book_Ids__c.split(';');
                for(String item : items) {
                    pricebookIds.add(item);
                }
                
            }
            if(tempSetting.Product_Names_For_Old_logic__c != null && tempSetting.Product_Names_For_Old_logic__c != '') {
                List<String> items = tempSetting.Product_Names_For_Old_logic__c.split(',');
                for(String item : items) {
                    productNames.add(item);
                }
            }
        }
        oppFields = SObjectType.Opportunity.FieldSets.Default_Field_Set.getFields();
        Map<String, Schema.SObjectField> oppFieldsMap = Schema.SObjectType.Opportunity.fields.getMap();
        Schema.FieldSet fieldSetObj = SObjectType.Opportunity.FieldSets.getMap().get(fieldsetName);
        if(fieldSetObj != null ) {
            oppFields = fieldSetObj.getFields();
            for(Schema.FieldSetMember item : oppFields) {
                system.debug('field : '+item.getFieldPath());
                //system.debug('item : '+(String) oppFieldsMap.get(item.getFieldPath()).getDescribe().getDefaultValue());
                if(oppFieldsMap.get(item.getFieldPath()).getDescribe().getDefaultValue() != null) {
                    this.opportunityRecord.put(item.getFieldPath(), oppFieldsMap.get(item.getFieldPath()).getDescribe().getDefaultValue());
                }
                if(oppFieldsMap.get(item.getFieldPath()).getDescribe().getDefaultValueFormula() != null) {
                    this.opportunityRecord.put(item.getFieldPath(), oppFieldsMap.get(item.getFieldPath()).getDescribe().getDefaultValueFormula());
                }
            }
        }
        stageProbability = [SELECT ApiName,DefaultProbability FROM OpportunityStage];
        
    }
    
    public void prepareRecordTypes(){
        recordTypesToDisplay = new List<recordTypeItem>();
        List<Opportunity_Setting__c> settings = [SELECT ID,Field_Set_Name__c,Record_Type_Group_Name__c,Product_Names_For_Old_logic__c, Price_Book_Ids__c, Record_Type_Name__c FROM Opportunity_Setting__c];
        Map<String, Opportunity_Setting__c> rt_nameToSetting = new Map<String, Opportunity_Setting__c>();
        for(Opportunity_Setting__c item: settings) {
            rt_nameToSetting.put(item.Record_Type_Name__c,item);
        }
        List<Schema.RecordTypeInfo> RT_info = Opportunity.SObjectType.getDescribe().getRecordTypeInfos();
        recordTypes = new List<SelectOption>();
        Set<Id> recordTypeIds = new Set<Id>();
        for(Schema.RecordTypeInfo item : RT_info) {
            if(item.isAvailable() && item.isMaster() == false) {
                recordTypes.add(new SelectOption(item.getRecordTypeId(),item.getName()));
                recordTypeIds.add(item.getRecordTypeId());
            }
        }
        List<RecordType> recordTypeList = [SELECT Id,Description, DeveloperName,IsActive,Name,SobjectType FROM RecordType WHERE SobjectType='Opportunity' AND IsActive = true AND Id IN: recordTypeIds ORDER BY Name];
        for(RecordType rType: recordTypeList){
            RecordTypeItem item = new RecordTypeItem();
            item.R_Type = rType;
            Opportunity_Setting__c tempSetting = rt_nameToSetting.get(rType.DeveloperName);
            if(tempSetting != null ) {
                item.RecordTypeGroup = tempSetting.Record_Type_Group_Name__c;
            }
            recordTypesToDisplay.add(item);
        }
        Map<String, Integer> groupMap = new Map<String, Integer>();
        for(RecordTypeItem item : recordTypesToDisplay) {
            if(item.RecordTypeGroup != null) {
                Integer i = 0;
                String tempGroupName = item.RecordTypeGroup;
                if(groupMap.containsKey(item.RecordTypeGroup)) {
                    i = groupMap.get(item.RecordTypeGroup);
                    item.RecordTypeGroup = null;
                    
                }
                i = i+1;
                system.debug('iiii-----'+i);
                groupMap.put(tempGroupName, i);
            }
        }
        system.debug('groupMap-----'+groupMap);
        for(RecordTypeItem item : recordTypesToDisplay) {
            if(item.RecordTypeGroup != null) {
                item.rowspan = groupMap.get(item.RecordTypeGroup);
            }
        }
    }

    public PageReference deleteRowElement() {
        Integer inElelment = null;
        String inputParam = ApexPages.currentPage().getParameters().get('rowNumber');
        system.debug('inputParam====='+inputParam);
        if(inputParam != null && inputParam !='') {
            inElelment = Integer.valueof(inputParam);
        }
        if(inElelment != null) {
            for(Integer i =0; i< products.size() ; i++) {
                if(inElelment == i) {
                    if(products[i].Id != null) {
                        if(isCloneAction == false) {
                            productsTodelete.add(products[i]);
                        }
                    }
                    products.remove(i);
                }
            }
        }
        return null;
    }
    
    public PageReference calculatemonth () {
        Integer inElelment = null;
        String inputParam = ApexPages.currentPage().getParameters().get('rowNumber');
        system.debug('inputParam====='+inputParam);
        if(inputParam != null && inputParam !='') {
            inElelment = Integer.valueof(inputParam);
        }
        if(inElelment != null) {
            for(Integer i =0; i< products.size() ; i++) {
                if(inElelment == i) {
                    Decimal totalValue = products[i].UnitPrice;
                    
                    if(totalValue == null) {
                        totalValue = 0;
                    }

                    products[i].X1_Month__c = ((totalValue / 100 ) * 2).setScale(2);
                    products[i].X2_Month__c = ((totalValue / 100 ) * 4).setScale(2);
                    products[i].X3_Month__c = ((totalValue / 100 ) * 6).setScale(2);
                    products[i].X4_Month__c = ((totalValue / 100 ) * 5).setScale(2);
                    products[i].X5_Month__c = ((totalValue / 100 ) * 5).setScale(2);
                    products[i].X6_Month__c = ((totalValue / 100 ) * 8).setScale(2);
                    products[i].X7_Month__c = ((totalValue / 100 ) * 9).setScale(2);
                    products[i].X8_Month__c = ((totalValue / 100 ) * 12).setScale(2);
                    products[i].X9_Month__c = ((totalValue / 100 ) * 11).setScale(2);
                    products[i].X10_Month__c = ((totalValue / 100 ) * 11).setScale(2);
                    products[i].X11_Month__c = ((totalValue / 100 ) * 11).setScale(2);
                    products[i].X12_Month__c = ((totalValue / 100 ) * 16).setScale(2);
                    break;
                }
            }
        }
        return null;
    }
    public PageReference calculateTotalValue () {
        Integer inElelment = null;
        String inputParam = ApexPages.currentPage().getParameters().get('rowNumber');
        system.debug('inputParam====='+inputParam);
        if(inputParam != null && inputParam !='') {
            inElelment = Integer.valueof(inputParam);
        }
        if(inElelment != null) {
            for(Integer i =0; i< products.size() ; i++) {
                if(inElelment == i) {
                    Decimal totalValue = 0; 
                    totalvalue += (products[i].X1_Month__c != null ) ? products[i].X1_Month__c : 0;
                    totalvalue += (products[i].X2_Month__c != null ) ? products[i].X2_Month__c : 0;
                    totalvalue += (products[i].X3_Month__c != null ) ? products[i].X3_Month__c : 0;
                    totalvalue += (products[i].X4_Month__c != null ) ? products[i].X4_Month__c : 0;
                    totalvalue += (products[i].X5_Month__c != null ) ? products[i].X5_Month__c : 0;
                    totalvalue += (products[i].X6_Month__c != null ) ? products[i].X6_Month__c : 0;
                    totalvalue += (products[i].X7_Month__c != null ) ? products[i].X7_Month__c : 0;
                    totalvalue += (products[i].X8_Month__c != null ) ? products[i].X8_Month__c : 0;
                    totalvalue += (products[i].X9_Month__c != null ) ? products[i].X9_Month__c : 0;
                    totalvalue += (products[i].X10_Month__c != null ) ? products[i].X10_Month__c : 0;
                    totalvalue += (products[i].X11_Month__c != null ) ? products[i].X11_Month__c : 0;
                    totalvalue += (products[i].X12_Month__c != null ) ? products[i].X12_Month__c : 0;
                    products[i].UnitPrice = totalvalue.setScale(2);
                    break;
                }
            }
        }
        return null;
    }
    
    
    public PageReference addProduct() {
        if(opportunityRecord.Start_From__c == null) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Please_select_Start_month_for_this_opportunity));
            return null;
        }
        products.add(new OpportunityLineItem());
        availabelProducts = prepareAvailabelProducts();
        System.debug('123: ' + products);
        return null;
    }
    
    public List<SelectOption> prepareAvailabelProducts() {
        List<PricebookEntry> relatedProducts  = new List<PricebookEntry>();
        if(pricebookIds.size() > 0) {
            Id priceBookFroSetting = pricebookIds[0];
            if(this.opportunityRecord.PriceBook2Id != null && priceBookFroSetting != this.opportunityRecord.PriceBook2Id) {
                system.debug('PRODUCT NAMES --'+productNames);
                relatedProducts = [SELECT Product2Id, Product2.Name from PricebookEntry WHERE CurrencyIsoCode =: this.opportunityRecord.CurrencyIsoCode AND Product2.Name IN :productNames AND IsActive = true AND PriceBook2Id =:this.opportunityRecord.PriceBook2Id ORDER BY Product2.Name];
            }
            else {
                system.debug('CURRENCY CODE -2---'+this.opportunityRecord.CurrencyIsoCode);
                relatedProducts = [SELECT Product2Id, Product2.Name from PricebookEntry WHERE CurrencyIsoCode =: this.opportunityRecord.CurrencyIsoCode AND Pricebook2Id IN :pricebookIds AND IsActive = true ORDER BY Product2.Name];
            }
        }
        else {
            system.debug('CURRENCY CODE -1---'+this.opportunityRecord.CurrencyIsoCode);
            relatedProducts = [SELECT Product2Id, Product2.Name from PricebookEntry WHERE CurrencyIsoCode =: this.opportunityRecord.CurrencyIsoCode   AND IsActive = true  ORDER BY Product2.Name];
        }
        
        List<SelectOption> items = new List<SelectOption>();
        for(PricebookEntry item : relatedProducts) {
            items.add(new SelectOption(item.Id, item.Product2.Name));
        }
        return items;
    }
    
    
    public PageReference saveRecords () {
        if(products.isEmpty()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.No_Products_For_Opportunity));
            return null;
        }
        Savepoint sp = Database.setSavepoint();
        Boolean isValidProducts = true;
        for(OpportunityLineItem item : products) {
            system.debug('==='+item.CurrencyIsoCode);
            system.debug('==='+this.opportunityRecord.CurrencyIsoCode);
            if(item.CurrencyIsoCode != null && item.CurrencyIsoCode != this.opportunityRecord.CurrencyIsoCode) {
                isValidProducts = false;
            }
        }
        if(isValidProducts == false) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Invalid_Products_For_Opportunity));
            return null;
        }
        try{
            if(isCloneAction) {
                this.opportunityRecord = opportunityRecord.clone();
                this.opportunityRecord.OwnerId = UserInfo.getUserId();
                products = products.deepClone();
                for(OpportunityLineItem item: products) {
                    item.OpportunityId = null;
                }
            }
            //if(isShowOpportuntiy) {
                //upsert ;
                Database.UpsertResult upsertRes = Database.upsert(opportunityRecord, false); 
                if (upsertRes.isSuccess() == false) {
                    String errorMessage = '';
                    for(Database.Error err : upsertRes.getErrors()) {
                        errorMessage += err.getMessage();
                    }
                    Database.rollback( sp );
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                    return null;
                }
            //}
            List<OpportunityLineItem> itemsToInsert = new List<OpportunityLineItem>();
            for(OpportunityLineItem item : products) {
                system.debug(item.PricebookEntryId);
                if(item.PricebookEntryId != null) {
                    if(isShowOpportuntiy || item.OpportunityId == null) {
                        item.OpportunityId = opportunityRecord.Id;
                    }
                    system.debug(item.X1_Month__c);
                    Decimal totalvalue =0;
                    totalvalue += (item.X1_Month__c != null ) ? item.X1_Month__c : 0;
                    totalvalue += (item.X2_Month__c != null ) ? item.X2_Month__c : 0;
                    totalvalue += (item.X3_Month__c != null ) ? item.X3_Month__c : 0;
                    totalvalue += (item.X4_Month__c != null ) ? item.X4_Month__c : 0;
                    totalvalue += (item.X5_Month__c != null ) ? item.X5_Month__c : 0;
                    totalvalue += (item.X6_Month__c != null ) ? item.X6_Month__c : 0;
                    totalvalue += (item.X7_Month__c != null ) ? item.X7_Month__c : 0;
                    totalvalue += (item.X8_Month__c != null ) ? item.X8_Month__c : 0;
                    totalvalue += (item.X9_Month__c != null ) ? item.X9_Month__c : 0;
                    totalvalue += (item.X10_Month__c != null ) ? item.X10_Month__c : 0;
                    totalvalue += (item.X11_Month__c != null ) ? item.X11_Month__c : 0;
                    totalvalue += (item.X12_Month__c != null ) ? item.X12_Month__c : 0;
                    if(totalvalue != null && totalvalue > item.UnitPrice) {
                        item.UnitPrice.addError(Label.Total_Error);
                        return null;
                    }
                    itemsToInsert.add(item);
                }
            }
            system.debug(itemsToInsert);
            upsert itemsToInsert;
            if(productsTodelete.size () > 0) {
                delete productsTodelete;
            }
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            Database.rollback( sp );
            return null;
        }
        return  new PageReference('/'+opportunityRecord.Id);
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