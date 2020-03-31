public class RC_InvoiceTemplatesHTMLController {
    
  public Id ContractId;
 
  public String currencyStr { get; set; }
  public void setContractId (String s) {
    contractId = s;
  }
    
  public String getContractId() {
    return contractId;
  } 
  public List<Invoice_Template__c> getTemplates(){
      Contract contract = [SELECT ID,CurrencyIsoCode FROM Contract WHERE Id =: contractId];
      List<Invoice_Template__c> l_templates =   [SELECT ID, NAME, Product_Group__r.Label__c, Pricing_Model__c, Payment_Terms_Code__c, Invoice_Details__c, Invoice_Level__c, Fees_Calculation_model__c,
                        (SELECT ID, NAME,ProductCustom__r.Name,Product_Price__r.Text_Price__c, ProductCustom__r.Measure__c ,Is_Price_lower__c, CurrencyIsoCode, Price__c , Price_Percent__c,Product_Price__r.Minimum_Price_Currency__c,
                        Product_Price__r.Minimum_Price_Percent__c, Main_Contract_Price__c FROM Contract_Prices__r WHERE Ending_Date__c  = null ORDER BY ProductCustom__r.Order__c), Is_Payment_Terms_Higher__c
                         FROM Invoice_Template__c WHERE Contract__c =:contractId  AND End_Date__c = null ORDER BY Product_Group__r.Order__c];
       currencyStr = contract.CurrencyIsoCode;
        for(Invoice_Template__c item : l_templates) {
            for(Contract_Price__c cp : item.Contract_Prices__r) {
                if(contract.CurrencyIsoCode != cp.CurrencyIsoCode  && cp.Price__c != null && cp.Price_Percent__c == null) {
                    currencyStr = cp.CurrencyIsoCode;
                    break;
                }
            }
        }
      return l_templates;
  }
}