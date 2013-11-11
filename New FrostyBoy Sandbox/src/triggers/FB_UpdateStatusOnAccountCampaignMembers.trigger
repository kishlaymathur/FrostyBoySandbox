trigger FB_UpdateStatusOnAccountCampaignMembers on Account (after update) 
{
    //Author:Rachit Bhargava
    public Map<String,String> mapOfIdAndStatus ;
   // public String AccId;
    
    for(Account instance:Trigger.new)
    {
        mapOfIdAndStatus = new Map<String,String>();
        //AccId = instance.Id;
        mapOfIdAndStatus.put(instance.Id , instance.Account_Status__c);
    }
  /*  Account_Campaign_Member__c instanceOfACM = [select Id,Campaign__c from Account_Campaign_Member__c where Account__c=:AccId limit 1];
    Campaign checkIsActive = [select IsActive from Campaign where Id=:instanceOfACM.Campaign__c limit 1];
    for(Account instance:Trigger.new)
    {
        if(Trigger.oldMap.get(instance.Id).Account_Status__c != instance.Account_Status__c)
        { 
            if(checkIsActive.IsActive)
            {
                instanceOfACM.Account_Status1__c = mapOfIdAndStatus.get(instance.Id);
                database.update(instanceOfACM);
            }
        }
    }*/
    List<Account_Campaign_Member__c> listToUpdate = new List<Account_Campaign_Member__c>();
    for(Account_Campaign_Member__c instance : [select Id,Account_Status1__c,Account__c from Account_Campaign_Member__c where Campaign__r.isActive = true AND Account__c IN :mapOfIdAndStatus.keySet()]){
        if(instance.Account_Status1__c != mapOfIdAndStatus.get(instance.Account__c)){
            instance.Account_Status1__c = mapOfIdAndStatus.get(instance.Account__c);
            listToUpdate.add(instance);
        }
     }
     if(listToUpdate.size() > 0){
         database.update(listToUpdate);
     }
}