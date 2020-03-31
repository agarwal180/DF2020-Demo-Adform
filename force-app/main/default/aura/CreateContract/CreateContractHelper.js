({
	getContacts : function(component) {
        var action = component.get("c.getRelatedContacts");
        action.setParams({
            recId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var res = response.getReturnValue();
            if (res.length > 0) {
                component.set("v.SelectedContact", res[0].Id);
                component.set("v.SelectedEmail", res[0].Email);
            }
            component.set("v.l_contacts", res);
        });
        $A.enqueueAction(action);
    },
    getRecordTypes : function(component) {
        var action = component.get("c.getRecordTypes");
        action.setParams({
            
        });
        action.setCallback(this, function(response) {
            var res = response.getReturnValue();
            component.set("v.selectedRT", res[0].Id);
            component.set("v.l_recordTypes", res);
        });
        $A.enqueueAction(action);
    },
    getOpportunity : function(component) {
        var action = component.get("c.getOpportunity");
        action.setParams({
            recId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var res = response.getReturnValue();
            component.set("v.opp", res);
        });
        $A.enqueueAction(action);
    },
    
    
})