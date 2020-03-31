({
	redirectToEmailTemplate : function(component) {
        var sobjectId = component.get("v.recordId");
        var url = "/_ui/core/email/author/EmailAuthor?p3_lkid="+sobjectId+"&retURL=/"+sobjectId+"&template_id=00X0J000001ezZy&p24=rfp@adform.com&p5=";
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url,
            "isredirect": false
        });
        urlEvent.fire();
	},
    
    closePopUp : function(){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})