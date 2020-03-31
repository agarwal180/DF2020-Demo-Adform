public class ContractPriceTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public ContractPriceTriggerHandler (boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(List<Contract_Price__c> l_new) {
        Map<Id, Product__c> m_products = new Map<Id, Product__c>();
        for(Contract_Price__c item : l_new) {
            if (item.ProductCustom__c != null) {
                m_products.put(item.ProductCustom__c ,null);
            }
        }
        if (m_products.size() > 0) {
            m_products = new Map<Id, Product__c>([SELECT Id, Additional_increment_size__c,
                    Banner_weight_KB_from__c, Banner_weight_KB_to__c, Tier_Name__c, Tier_Type__c,Volume_from__c,Volume_to__c 
                    FROM Product__c WHERE Id IN:m_products.keySet() AND (
                    Tier_Name__c != null OR Additional_increment_size__c != null
                    OR Banner_weight_KB_to__c != null OR Banner_weight_KB_from__c != null OR Volume_from__c != null OR Volume_to__c != null)]);
            if (m_products.size() > 0) {
                for (Contract_Price__c item : l_new) {
                    if (item.ProductCustom__c != null && m_products.get(item.ProductCustom__c) != null) {
                        Product__c product = m_products.get(item.ProductCustom__c);
                        item.Weight_Tier__c = product.Additional_increment_size__c;
                        item.Banner_weight_KB_from__c = product.Banner_weight_KB_from__c;
                        item.Banner_weight_KB_to__c = product.Banner_weight_KB_to__c;
                        item.Tier_Type__c = product.Tier_Type__c;
                        item.Tier_Name__c = product.Tier_Name__c;
                        item.Volume_from__c = product.Volume_from__c;
                        item.Volume_to__c = product.Volume_to__c;
                    }
                }
            }
        }
    }

    public void OnAfterInsert(List<Contract_Price__c> l_new) {
        Set<Id> s_contractIds = new Set<Id>(); 
        Set<Id> s_ids = new Set<Id>();
        for(Contract_Price__c item : l_new) {
            if (item.Account__c != null) {
                s_ids.add(item.Account__c);
            }
            if (item.Contract__c != null ) {
                s_contractIds.add(item.Contract__c);
            }
        }
        updateContract(s_contractIds);
        updateAccount(s_ids);
    }

   
    
    public void OnAfterUpdate(List<Contract_Price__c> l_old,List<Contract_Price__c> l_new, Map<Id, Contract_Price__c> m_new, Map<Id, Contract_Price__c> m_old ){
        Set<Id> s_ids = new Set<Id>();
        Set<Id> s_contractIds = new Set<Id>(); 
        List<Contract> l_contracts = new List<Contract>();
        for(Contract_Price__c item : l_new) {
            Contract_Price__c oldrec = m_old.get(item.Id);
            if (item.Account__c != null) {
                s_ids.add(item.Account__c);
            }
            if (item.Contract__c != null && (item.Price__c != oldrec.Price__c || item.Price_Percent__c != oldrec.Price_Percent__c || item.MInimum_Price_Currency__c != oldrec.MInimum_Price_Currency__c || item.Minimum_Price_Percent__c != oldrec.Minimum_Price_Percent__c)) {
                s_contractIds.add(item.Contract__c);
            }
        }
        updateContract(s_contractIds);
        updateAccount(s_ids);
    }
    
    
    public void OnAfterDelete(List<Contract_Price__c> l_old){
        Set<Id> s_contractIds = new Set<Id>(); 
        Set<Id> s_ids = new Set<Id>();
        for(Contract_Price__c item : l_old) {
            if (item.Account__c != null) {
                s_ids.add(item.Account__c);
            }
            if (item.Contract__c != null) {
                s_contractIds.add(item.Contract__c);
            }
        }
        updateAccount(s_ids);
        updateContract(s_contractIds);
    }

    public static void updateContract(Set<Id> s_ids) {
        if(s_ids.size() > 0){
            List<Contract> l_contracts = [SELECT Id, Approval_Status__c, Total_Minimum_Price__c, Total_Price__c, (SELECT Id,Ending_Date__c,  Is_Price_lower__c, Price__c, Price_Percent__c, MInimum_Price_Currency__c, Minimum_Price_Percent__c FROM Contract_Prices__r) FROM  Contract WHERE Id IN:s_ids ];
            for(Contract c : l_contracts) {
                Boolean isUpdateDeeded = false;
                Decimal totalPrice = 0;
                Decimal totalMinimum = 0;
                Boolean isPriceLower = false;
                for(Contract_Price__c cp : c.Contract_Prices__r) {
                    if(cp.Ending_Date__c == null) {
                        isUpdateDeeded = true;
                        if (cp.Price__c != null && cp.MInimum_Price_Currency__c != null && cp.MInimum_Price_Currency__c != 0 ) {
                            totalPrice+=cp.Price__c;
                        }
                        else if (cp.Price_Percent__c != null && cp.Minimum_Price_Percent__c != null && cp.Minimum_Price_Percent__c != 0) {
                            totalPrice+=cp.Price_Percent__c;
                        }
                        if (cp.Is_Price_lower__c) {
                            isPriceLower = cp.Is_Price_lower__c;
                        }
                    }
                }
                if (isUpdateDeeded) {
                    c.Total_Minimum_Price__c = totalMinimum;
                    c.Total_Price__c = totalPrice;
                    c.Is_Approval_needed_Contract_prices__c = isPriceLower;
                }
            }
            update l_contracts;
        }
    }

    
    public static void updateAccount(Set<Id> s_ids){
        if (s_ids.size() > 0) {
            List<Account> l_accounts = [SELECT Id, Navision_Base_Unit_of_Measure__c,  (SELECT Id, Unit_of_Measure_Code__c
                                         FROM Contract_Prices__r WHERE Ending_Date__c = null)  FROM Account WHERE Id IN: s_ids];
            for(Account acc : l_accounts)  {
                acc.Navision_Base_Unit_of_Measure__c = null;
                Set<String> s_measure = new Set<String>();
                for(Contract_Price__c cp : acc.Contract_Prices__r) {
                    if (String.IsNotBlank(cp.Unit_of_Measure_Code__c)){
                        s_measure.add(cp.Unit_of_Measure_Code__c);
                    }
                }
                if (s_measure.size() > 0) {
                    acc.Navision_Base_Unit_of_Measure__c = String.join( new List<String>(s_measure),';');
                }
            }

            update l_accounts;
        }
    }
}