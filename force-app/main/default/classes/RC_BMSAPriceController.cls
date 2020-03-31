public with sharing class RC_BMSAPriceController {
    public List<Invoice_Template__c> l_templates { get; set; }
    public List<Contract_Price__c> l_contractPrices { get; set; }

    public String currencyStr { get; set; }
    public RC_BMSAPriceController(ApexPages.StandardController con){
        l_contractPrices = new List<Contract_Price__c>();
        if (Test.isRunningTest() == false) {
            con.addFields(new List<String>{'RTB_options__c','Invoice_Type__c', 'CurrencyIsoCode'});
        }
        Contract contract = (Contract) con.getRecord();
        Contract contractTemp = [SELECT ID, CurrencyIsoCode FROM Contract WHERE Id =: contract.Id];
        l_templates = [SELECT ID, NAME, Product_Group__r.Label__c, Product_Group__r.Name,Product_Group__r.Hide_on_Print_View__c ,Product_Group__r.Read_Only__c , Product_Group__r.Print_Out_Label__c, Fees_Calculation_model__c, Pricing_Model__c,
                        (SELECT ID, NAME, ProductCustom__r.Name, ProductCustom__r.Measure__c,Product_Price__r.Text_Price__c,
                        ProductCustom__r.Period_Of_Invoicing__c, CurrencyIsoCode, Price__c,
                        Price_Percent__c, Main_Contract_Price__c, ProductCustom__r.Hide_Pricing_Model__c, ProductCustom__r.Product_Group__r.Read_Only__c, Billing_Resource__r.Name FROM Contract_Prices__r ORDER BY ProductCustom__r.Order__c)
                        FROM Invoice_Template__c WHERE Contract__c =:contract.Id ORDER BY Product_Group__r.Order__c];
        currencyStr = contractTemp.CurrencyIsoCode;
        for(Invoice_Template__c item : l_templates) {
            for(Contract_Price__c cp : item.Contract_Prices__r) {
                if(cp.Billing_Resource__r.Name == '(DO NOT USE) Brand Safety Costs - DoubleVerify2'){
                    l_contractPrices.add(cp);
                }
                if( cp.Price__c != null && cp.Price_Percent__c == null && currencyStr != cp.CurrencyIsoCode && cp.ProductCustom__r.Hide_Pricing_Model__c == false && cp.ProductCustom__r.Product_Group__r.Read_Only__c == false) {
                    currencyStr = cp.CurrencyIsoCode;
                }
            }
        }
        for(Multiple_Billing_Resource__c mbr : [SELECT Id, Name, Product__c FROM Multiple_Billing_Resource__c WHERE Main_Billing_Resource__c = false]){
            for(Contract_Price__c cp : l_contractPrices){
                if(cp.ProductCustom__c == mbr.Product__c){
                    cp.Multiple_Billing_Resource_Name__c = mbr.Name;
                }
            }
        }
    }
}