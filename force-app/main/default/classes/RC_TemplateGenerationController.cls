/* 
 * Name          : RC_TemplateGenerationController
 * Author        : Andrei Pruzan
 * Description   : Controller for RC_TemplateGeneration page
 * Visulforce page : RC_TemplateGeneration
 * Unit test : 
 * Maintenance History: 
 * 2017/09/26 - AP - 1.0 - Created. 
*/
public without sharing class RC_TemplateGenerationController {

    public class ProductGroup{
        Public Product_Group__c productGroup { get; set; }
        public List<Product> products { get; set; }
    }
    public class Product  {
        public Product__c product { get; set; }
        public Product_Price__c price { get; set; }
    }
    
    public List<ProductGroup> l_productGroups { get; set; }
    
    public RC_TemplateGenerationController() {
        l_productGroups = new List<ProductGroup>();
        /*List<Product_Group__c> l_obPg = [SELECT ID, Label__c, Payment_Terms__c FROM Product_Group__c WHERE is_active__c = true ORDER BY Order__c];
        List<Product__c> l_obp = [SELECT ID, Name, Product_Group__c, Help_Text__c, Measure__c,
                                (SELECT ID, CurrencyIsoCode, Price__c FROM Product_Prices__r)  
                                 FROM Product__c WHERE Product_Group__c IN :l_obPg  ORDER BY Order__c];
        Map<Id, List<Product__c>> m_productGroups = new Map<Id, List<Product__c>>();
        for(Product__c item : l_obp) {
            List<Product__c> l_temp = new List<Product__c>();
            if (m_productGroups.containsKey(item.Product_Group__c) == true) {
                l_temp = m_productGroups.get(item.Product_Group__c);
            }    
            l_temp.add(item);
            m_productGroups.put(item.Product_Group__c, l_temp);
        }
        
        for(Product_Group__c pg : l_obPg) {
            ProductGroup temppg = new ProductGroup();
            temppg.productGroup = pg;
            List<Product> l_temp = new List<Product>();
            List<Product__c> l_products = m_productGroups.get(pg.Id);
            if (l_products == null) {
                l_products = new List<Product__c> ();
            }
            for(Product__c item : l_products) {
                Product tempp = new Product();
                tempp.product = item;
                if (item.Product_Prices__r.size() > 0) {
                    tempp.price = item.Product_Prices__r[0];
                }
                l_temp.add(tempp);
            }
            temppg.products = l_temp;
            l_productGroups.add(temppg);
        }*/
    }
}