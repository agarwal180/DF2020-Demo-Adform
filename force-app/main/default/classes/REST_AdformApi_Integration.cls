/* 
  * Name    : REST_AdformApi_Integration 
  * Author  : Andrei Pruzan
  * Description   : Class used to retrieve data in json format in rest api
  * Maintenance History: 7/10/2018
*/
@RestResource(urlMapping='/AdformAPI/*')
global with sharing class REST_AdformApi_Integration {

    @HttpGet
    global static void getData() {
        RestRequest req = RestContext.request;   
        String LastModifiedDateFrom = req.params.get('LastModifiedDateFrom');
        String LastModifiedDateTo = req.params.get('LastModifiedDateTo');
        String CreatedDateFrom = req.params.get('CreatedDateFrom');
        String CreatedDateTo = req.params.get('CreatedDateTo');
        String limitVal = req.params.get('Limit');
        String apiName = req.requestURI;
        String methodName = req.requestURI.substringAfterLast('/');
        apiName = apiName.substringAfter('AdformAPI/');
        apiName = apiName.substringBefore('/');
        REST_AdformResponse response = new REST_AdformResponse();
        response.lastModifiedDateFrom = DateTimeParcing(LastModifiedDateFrom);
        response.lastModifiedDateTo = DateTimeParcing(LastModifiedDateTo);
        response.createdDateFrom = DateTimeParcing(CreatedDateFrom);
        response.createdDateTo = DateTimeParcing(CreatedDateTo);
        response.api_objectName = apiName;
        response.methodName = methodName;
        String result = null;
        Integer statusCode = 200;
        RestContext.response.addHeader('Content-Type', 'text;charset=UTF-8');
        if (methodName != 'getIds' && methodName != 'getRecords') {
            result = 'Method not supported: '+methodName;
            statusCode = 405;
        }
        else {
            List<API_Object__c> l_objects = getObject(apiName);
            if (l_objects.size() == 0) {
                result = 'Object not supported';
                statusCode = 405;
            }
            else {
                List<API_Field__c> l_APIfields = getFields(l_objects[0].Id);
                if (l_APIfields.size() == 0) {
                    result = 'Object not supported';
                    statusCode = 405;
                }
                else {
                    String whereStr = '';
                    if (LastModifiedDateFrom != null && LastModifiedDateTo != null && response.lastModifiedDateFrom != null && response.lastModifiedDateTo != null) {
                        whereStr= ' WHERE LastModifiedDate >=' +ConvertDateTimeToStr(response.lastModifiedDateFrom)+ ' AND LastModifiedDate <='+ConvertDateTimeToStr(response.lastModifiedDateTo);
                    }
                    else if (LastModifiedDateFrom != null && response.lastModifiedDateFrom != null ) {
                        whereStr= ' WHERE LastModifiedDate >=' +ConvertDateTimeToStr(response.lastModifiedDateFrom);
                    }
                    else if (LastModifiedDateTo != null && response.lastModifiedDateTo != null ) {
                        whereStr= ' WHERE LastModifiedDate <='+ConvertDateTimeToStr(response.lastModifiedDateTo);
                    }
                    else if (CreatedDateFrom != null && CreatedDateTo != null && response.createdDateFrom != null && response.createdDateTo != null) {
                        whereStr= ' WHERE CreatedDate >=' +ConvertDateTimeToStr(response.createdDateFrom)+ ' AND CreatedDate <='+ConvertDateTimeToStr(response.createdDateTo);
                    }
                    else if (CreatedDateFrom != null && response.createdDateFrom != null ) {
                        whereStr= ' WHERE CreatedDate >=' +ConvertDateTimeToStr(response.createdDateFrom);
                    }
                    else if (CreatedDateTo != null && response.createdDateTo != null ) {
                        whereStr= ' WHERE CreatedDate <='+ConvertDateTimeToStr(response.createdDateTo);
                    }
                    List<Map<String, Object>> m_results = getRecords(apiName, l_APIfields, methodName, whereStr, limitVal);
                    response.results = m_results;
                    result = JSON.serialize(response);
                    RestContext.response.addHeader('Content-Type', 'application/json');
                }
            }
            
        }
        RestContext.response.responseBody = Blob.valueOf(result);
        RestContext.response.statusCode = statusCode;
    }

    @HttpPost   
    global static void postData() {
        RestRequest req = RestContext.request;
        List<String> l_ids =  (List<String>) System.JSON.deserialize(req.requestBody.toString(), List<String>.class);
        String apiName = req.requestURI;
        String methodName = req.requestURI.substringAfterLast('/');
        apiName = apiName.substringAfter('AdformAPI/');
        apiName = apiName.substringBefore('/');
        REST_AdformResponse response = new REST_AdformResponse();
        response.lastModifiedDateFrom = null;
        response.lastModifiedDateTo = null;
        response.createdDateFrom = null;
        response.createdDateTo = null;
        response.api_objectName = apiName;
        response.methodName = methodName;
        String result = null;
        Integer statusCode = 200;
        RestContext.response.addHeader('Content-Type', 'text;charset=UTF-8');
        List<API_Object__c> l_objects = getObject(apiName); 
        if(methodName != 'getById') {
            result = 'Method not supported: '+methodName;
            statusCode = 405;
        }
        else {
            if (l_objects.size() == 0) {
                result = 'Object not supported';
                statusCode = 405;
            }
            else {
                List<API_Field__c> l_APIfields = getFields(l_objects[0].Id);
                if (l_APIfields.size() == 0) {
                    statusCode = 405;
                }
                else {
                    String whereStr = ' WHERE ID IN (\''+String.Join(l_ids, '\',\'')+'\')';
                    List<Map<String, Object>> m_results = getRecords(apiName, l_APIfields, methodName, whereStr, null);
                    response.results = m_results;
                    result = JSON.serialize(response);
                    RestContext.response.addHeader('Content-Type', 'application/json');
                }
            }
        }
        RestContext.response.responseBody = Blob.valueOf(result);
        RestContext.response.statusCode = statusCode;
    }

    public static List<API_Object__c> getObject(String objectName) {
        return  [SELECT ID FROM API_Object__c WHERE Api_Object_Name__c =: objectName AND Is_Active__c = true];
    }

    public static List<API_Field__c> getFields(Id objectId) {
        return [SELECT ID, Field_Name__c, Json_Attribute__c,Is_Parent__c, Parent_Relationship_Name__c FROM API_Field__c WHERE Api_Object__c = :objectId AND Is_Active__c = true];
    }
      
    public static List<Map<String, Object>> getRecords(String apiName, List<API_Field__c> l_APIfields, String methodType, String whereStr, String limitVal) {
        List<Map<String, Object>> m_results = new List<Map<String, Object>>();
        List<String> l_fields = new List<String>();
        for(API_Field__c item : l_APIfields) {
            if (item.Is_Parent__c == false) {
                l_fields.add(item.Field_Name__c);
            }
            else {
                l_fields.add(item.Parent_Relationship_Name__c+'.'+item.Field_Name__c);
            }
        }
        String soqlSTR = 'SELECT '+String.join(l_fields, ',')+' FROM '+apiName +' '+ whereStr;
        if (limitVal != null) {
            soqlSTR+=' LIMIT '+limitVal;
        }
        system.debug(soqlSTR);
        List<sObject> l_records = Database.query(soqlSTR);
        for(sObject item : l_records) {
            Map<String, Object> m_temp = new Map<String, Object>();
            m_temp.put('Id', item.Id);
            if (methodType != 'getIds') {
                for(API_Field__c  f: l_APIfields) {
                    if (f.Is_Parent__c == false) {
                        m_temp.put(f.Json_Attribute__c, item.get(f.Field_Name__c));
                    }
                    else {
                        m_temp.put(f.Json_Attribute__c, item.getSobject(f.Parent_Relationship_Name__c).get(f.Field_Name__c));
                    }
                }
            }
            m_results.add(m_temp);
        }
          return m_results;
    }

    public static string ConvertDateTimeToStr(DateTime indt) {
        return indt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
    }
    
    public static DateTime DateTimeParcing(String datetimestr){
      if (datetimestr != null) {
        try {
          return Datetime.Valueof(datetimestr);
        }
        catch(exception ex) {}
      }
      return null;
  }
}