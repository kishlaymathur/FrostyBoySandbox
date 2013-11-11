public class FB_ViewAllController {

    String currentAccountId = ApexPages.currentPage(). getParameters().get('id');
    public PageReference cancel() {
        PageReference pageRef = new PageReference('/'+currentAccountId);
        return pageRef;
    }


    public FB_ViewAllController() {

    }
    public Set<Task> listOfTask{get;set;}
    
    
    public List<Task> getTasks() {
        List<Task> abc = new List<Task>();
        listOfTask = new Set<Task>();
        //Task instance = new Task();
        
        for(Task instance:[select Id,Subject, WhoId,Who.Name, WhatId,What.Name, ActivityDate, Owner.Name, LastModifiedDate,Description, Follow_up_Comments__c from Task where WhatId=:currentAccountId])
        {
        listOfTask.add(instance);
        }
        List<Contact> listOfContact  = [select Id from Contact where AccountId =:currentAccountId];
        for(Task instance:[select Id,Subject, WhoId,Who.Name, WhatId,What.Name, ActivityDate, Owner.Name, LastModifiedDate,Description, Follow_up_Comments__c from Task where WhoId IN:listOfContact])
        {
        listOfTask.add(instance);
        }
        for(Task a:listOfTask)
        {
            abc.add(a);
        }
        return abc;
    }


    


    

}