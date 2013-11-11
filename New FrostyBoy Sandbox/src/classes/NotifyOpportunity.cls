global class NotifyOpportunity
{
    Webservice static String SendNotificationMail(String oppId)
    {
     String messageBody;
        String emailAddress;
        Opportunity opp = [select AccountId,Name,CreatedBy.Name,Account.Name,Description,StageName,CloseDate,Product_Group__c from Opportunity where Id = :oppId];
        Account currentAccount = [select ParentId,Name,Interested_In__c,Business_Category__c,Description from Account where Id = :opp.AccountId];
        Account parentAccount = [select Name,Type, primary_email__c from Account where Id = :currentAccount.ParentId];
        Messaging.SingleEmailMessage notificationMail = new Messaging.SingleEmailMessage(); 
        List<String> toAddresses = new List<String>();
        emailAddress=(String)parentAccount.Primary_Email__c;
        toAddresses.add(emailAddress);
        notificationMail.setToAddresses(toAddresses);
        notificationMail.setSubject('New opportunity linked to one of your accounts');
        messageBody='<html><body>Hi  '+parentAccount.Name+',<br/><br/>This mail is to inform that a new opportunity '+ opp.Name + ' has been linked with one of your clients.<br></br>Opportunity Information are as follows:<br/> Created by: '+ opp.CreatedBy.Name + '<br/> Client Name: '+ opp.Account.Name + '<br/>Opportunity Description: '+opp.Description +'<br/> Opportunity Stage: '+ opp.StageName+ '<br/>Opportunity Closed Date : '+opp.CloseDate.format() +'<br/> Product Group : '+ opp.Product_Group__c + '<body></html>';
        notificationMail.setHtmlBody(messageBody);
        notificationMail.setSaveAsActivity(true);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { notificationMail});  
        return 'success';
    }
}