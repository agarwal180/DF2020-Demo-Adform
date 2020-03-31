global with sharing class Utilities {
    
    public static String make15SymbolsId(id recordId) {
        String tempId = recordId;
        return tempId.substring(0, 15);
    }
    
    // update accounts, after that this account will be handle in billing integration
    public static void updateAccounts(Set<Id> s_ids){
        update [SELECT Id FROM Account WHERE Id IN:s_ids];
    }
    
    // convert object to string for XML
    public static String convertToString(object inParam) {
        String returnSTR = (inParam != null) ? String.valueOf(inParam) : '';
        if (inParam != null && inParam != '') {
            if (inParam instanceof Date) {
                returnSTR = returnSTR.replace(' ', 'T');
            }
            else if (inParam instanceof DateTime) {
                returnSTR = returnSTR.replace(' ', 'T');
            }
        }
        return returnSTR;
    }
    public static Boolean validateEmail(String email) {
        Boolean res = true;
          
        
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        
        if (!MyMatcher.matches()) {
            res = false;
        }
        return res; 
    }
    
    public static Id getWorkItemId(Id targetObjectId){
         Id retVal = null;
         List<ProcessInstance> l_pi = [Select ID, Status, TargetObject.Name 
                From ProcessInstance 
                Where TargetObjectID = :targetObjectId AND Status = 'Pending'];

        if(l_pi.size() > 0){
            ProcessInstance pi = l_pi[0];
            List<ProcessInstanceWorkitem> l_piwi = [select Id,OriginalActorId from ProcessInstanceWorkitem where ProcessInstanceId= :pi.Id LIMIT 1];
            if (l_piwi.size() > 0) {
                retVal = l_piwi[0].Id;
            }
        }
        return retVal;
    }

    public static Integer generateRandomFromRange(integer startNum, integer endNum){
        Integer returnValue;
        //first we will generate random boolean value which will decide if we want to
        //add the random number from startNum or will subtract random number from endNum
        Integer randomNumber = Integer.valueof((math.random() * 10));
        boolean addSubFlag = math.mod(randomNumber,2) == 0 ? true : false;

        Integer diffInRange = endNum - startNum;
        //Now find random number staring from 0 to diffInRange
        Integer randomNum = Math.mod(Math.round(Math.random() * diffInRange + 1), diffInRange);

        //If addSubFlag is true, we will add random number generated between 0 and diffInRange from start number
        //else we will subtract random number from end number
        if(addSubFlag){
            if(diffInRange > 1) {
                returnValue = startNum + randomNum;
            } else {
                returnValue = startNum;
            }
        } else {
            if(diffInRange > 1) {
                returnValue = endNum - randomNum;
            } else {
                returnValue = endNum;
            }
        }
        return returnValue;
    }

    //Finds a random string value from list of strings
    public static String findRandomStringFromList(List<String> values){
        Integer randomNumber;
        if(values.size() > 1){
            randomNumber = generateRandomFromRange(0,values.size() - 1);
        } else {
            randomNumber = 0;
        }
        return values[randomNumber];
    }

    //Finds a random object from list of objects
    public static Object findRandomObjectFromList(List<Object> values){
        Integer randomNumber;
        if(values.size() > 1){
            randomNumber = generateRandomFromRange(0, values.size() - 1);
        } else {
            randomNumber = 0;
        }
        return values[randomNumber];
    }
}