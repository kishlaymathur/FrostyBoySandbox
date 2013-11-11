global class NotifyAccount
{
     
    WebService static String sendEmailNotification(String accountId) 
    {
        String messageBody;
        String emailAddress;
        Account currentAccount = [select ParentId,Phone,Primary_Email__c,Name,Interested_In__c,Classification__c,BillingPostalCode,BillingCity,BillingStreet,BillingState,BillingCountry,Description from Account where Id = :accountId];
        Contact currentContact = [select Name from Contact where AccountId = :accountId limit 1];
        Account parentAccount = [select Name,Type, primary_email__c from Account where Id = :currentAccount.ParentId];
        Messaging.SingleEmailMessage notificationMail = new Messaging.SingleEmailMessage(); 
        List<String> toAddresses = new List<String>();
        String clientAddress = '';
        if(currentAccount.BillingStreet != null){
            clientAddress  += currentAccount.BillingStreet + ' ';
        }
        if(currentAccount.BillingCity != null){
            clientAddress  += currentAccount.BillingCity + ' ';
        }
        if(currentAccount.BillingState != null){
            clientAddress  += currentAccount.BillingState + ' ';
        }
        if(currentAccount.BillingPostalCode != null){
            clientAddress  += currentAccount.BillingPostalCode + ' ';
        }
        if(currentAccount.BillingCountry != null){
            clientAddress  += currentAccount.BillingCountry + ' ';
        }
        emailAddress=(String)parentAccount.Primary_Email__c;
        toAddresses.add(emailAddress);
        notificationMail.setToAddresses(toAddresses);
        notificationMail.setSubject('New account linked to your account');
        messageBody='<html><body>Hi  '+parentAccount.Name+',<br/><br/>This mail is to inform that an account \''+ currentAccount.Name + '\' has been linked with your account. Please follow up on this lead within the next 2 business days” .<br></br>Account Information are as follows:<br/><br/> Account Name: '+ currentAccount.Name + '<br/> Address: '+ clientAddress + '<br/> Contact Name: '+ currentContact.Name + '<br/>Phone: '+ currentAccount.Phone + '<br/> Email: ' + currentAccount.Primary_Email__c + '<br/>Interested In : ' + currentAccount.Interested_In__c + '<br/> Classification: '+ currentAccount.Classification__c+ '<br/> Description: '+ currentAccount.Description +'<body></html>';
        notificationMail.setHtmlBody(messageBody);
        notificationMail.setSaveAsActivity(true);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { notificationMail});  
        currentAccount.Notification_Mail_Sent__c = 'Notification Mail Sent to Parent Account';
        update currentAccount;
        return 'success';
    }
}