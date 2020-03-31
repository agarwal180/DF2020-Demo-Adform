({
    submit: function (component, event, helper) {
        helper.redirectToEmailTemplate(component);
    },
    
    closePopUp: function(component, event, helper) {
        helper.closePopUp();
    }
})