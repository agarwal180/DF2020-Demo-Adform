global without sharing class UtilitiesWithoutSharing {

    public static void recordApprove(Id targetObjectId){
         Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Auto approve for cloned record');
            req2.setAction('Approve'); //This is the action that is approve in your case, you can set it to Reject also
            //req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});//UserInfo.getUserId()});
            req2.setWorkitemId(Utilities.getWorkItemId(targetObjectId));
            // Submit the request for approval
            Approval.ProcessResult result2 =  Approval.process(req2);
    }

}