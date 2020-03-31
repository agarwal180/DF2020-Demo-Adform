/* 
  * Name    : REST_AdformResponse 
  * Author  : Andrei Pruzan
  * Description   : Class as response class for rest api
  * Maintenance History: 7/10/2018
*/
public class REST_AdformResponse{
    public DateTime lastModifiedDateFrom;
    public DateTime lastModifiedDateTo;
    public DateTime createdDateFrom;
    public DateTime createdDateTo;
    public String api_objectName;
    public String methodName;
    public List<Map<String,Object>> results;
}