global class FB_NotifyCase 
{
    WebService static String sendEmailNotification(String caseId,String emailId,String emailId1,String recipient) 
    {
        String messageBody;
        String emailAddress;
        String emailAddress1;
        Case newCase = [select Id, AccountId,Machine_Inventory__c, Machine_Inventory__r.Name,Machine_Inventory__r.Customer__r.BillingStreet,Machine_Inventory__r.Customer__r.BillingCity,Machine_Inventory__r.Customer__r.BillingState,Machine_Inventory__r.Customer__r.BillingCountry,Machine_Inventory__r.Customer__r.BillingPostalCode, Machine_Inventory__r.Machine_Number__r.Last_Service_Date__c, Machine_Inventory__r.Machine_Number__r.Name, Machine_Inventory__r.Machine_Number__r.Model_Type__c, Subject, Description, Reason, CreatedDate, CaseNumber from Case where Id=:caseId];
        Messaging.SingleEmailMessage notificationMail = new Messaging.SingleEmailMessage(); 
        List<String> toAddresses = new List<String>();
        //emailAddress=(String)parentAccount.Primary_Email__c;
        emailAddress=emailId;
        emailAddress1=emailId1;
        if(emailId!='')
        toAddresses.add(emailAddress);
        if(emailId1!='')
        toAddresses.add(emailAddress1);
        notificationMail.setToAddresses(toAddresses);
        notificationMail.setSubject(newCase.Subject);
        messageBody='<html><body>Hi  '+recipient+',<br/><br/>This mail is to inform that a Case \''+ newcase.CaseNumber + '\' has been created. Please follow up on this Case.” .<br></br>Case Information are as follows:<br/><br/> Case Number: '+ newCase.CaseNumber + '<br/> Case Reason: '+ newCase.Reason + '<br/> Machine Location: '+ newCase.Machine_Inventory__r.Customer__r.BillingStreet+' '+newCase.Machine_Inventory__r.Customer__r.BillingCity+' '+newCase.Machine_Inventory__r.Customer__r.BillingState+' '+newCase.Machine_Inventory__r.Customer__r.BillingCountry+' '+newCase.Machine_Inventory__r.Customer__r.BillingPostalCode+' ' + '<br/>Machine Serial Number: '+ newCase.Machine_Inventory__r.Machine_Number__r.Name + '<br/> Machine Type : ' + newCase.Machine_Inventory__r.Machine_Number__r.Model_Type__c + '<br/>Last Serviced Date : ' + (newCase.Machine_Inventory__r.Machine_Number__r.Last_Service_Date__c).format() + /*'<br/>Click the link below for more details<br/> https://cs5.salesforce.com/'+newCase.Id+'*/'<body></html>';
        notificationMail.setHtmlBody(messageBody);
        notificationMail.setSaveAsActivity(true);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { notificationMail});
        if(recipient=='Bevwizz')  
        {
            newCase.Notifcation_Mail_Sent__c = 'Bevwizz Notification Mail Sent';
        }
        else
        {
            newCase.Internal_Notification_Sent__c = 'Internal Notification Mail Sent';
        }
        update newCase;
        return 'Success';
    }
}