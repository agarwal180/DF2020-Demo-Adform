public class DoxisContract{
    public Address ci_invoiceAddress;
    public Address bi_shippingAddress;
    public String  md_subject;
    public String  md_company;
    public String  md_agreementType;
    public String  md_supplementType;
    public String  md_customer_name;
    public String  md_vat_number;
    public List<String>  md_navisionId;
    public List<String>  md_emails;
    public List<String>  md_salesOffice;
    public String  md_registrationCountry;
    public List<String>  md_admintoolIds;
    public String  md_effectiveDate;
    public String  md_endDate;
    public String  md_status;
    public String  md_withSLA;
    public String  md_prepayment;
    public String  md_fee;
    public String  md_minfee_effectiveDate;
    public String  md_comments;
    public String  md_id;
    public String  md_weblink;
    public String  md_statusDocument;
    public String  md_statusComment;
    public String  ci_account;
    public String  ci_company_registration_number;
    public String  ci_vat_number;
    public String  ci_contractDetails;
    public String  ci_contactEmail;
    public String  ci_customerType;
    public String  bi_account;
    public String  bi_company_registration_number;
    public String  bi_vat_number;
    public String  bi_invoicing_e_mail;
    public List<dataTable> services;
    public Boolean order;
    public Boolean noorder;
    

    public class dataTable{
      public String tableName;
      public tableHeader header;
      public List<tableValue> values;
    }

    public class tableHeader{
      public String column1;
      public String column2;
      public String column3;
      public String column4;
      public String column5;
      public String column6;
      public String column7;
      public String column8;
      public String column9;
      public String column10;
    }

    public class tableValue{
      public tableRow row;
    }

    public class tableRow{
      public String value1;
      public String value2;
      public String value3;
      public String value4;
      public String value5;
      public String value6;
      public String value7;
      public String value8;
      public String value9;
      public String value10;
    }
    
    public class Address {
      public String city;
      public String country;
      public String countryCode;
      public String postalCode;
      public String state;
      public String stateCode;
      public String street;
  }
  
  
  

}