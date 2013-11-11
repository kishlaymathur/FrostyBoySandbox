trigger UpdateAccountOnLeadConversion on Lead (after update) 
{
    Lead currentLead = Trigger.new[0];
        if(currentLead.ConvertedAccountId != null)
        {
              Account instance = [select id, ParentId from Account where id = :currentLead.ConvertedAccountId];
              instance.ParentId = currentLead.Parent_Account__c;
              instance.Description = currentLead.Description;
              instance.Account_Status__c='Lead';
              instance.Primary_Email__c = currentLead.Email;
              instance.AccountSource = currentLead.LeadSource;
              database.update(instance);
         }
}