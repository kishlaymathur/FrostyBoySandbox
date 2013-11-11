global class FB_ServiceCaseCreator implements Database.Batchable<sObject>
{
    global FB_ServiceCaseCreator ()
    {
        
    }
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String listOfMachinesInventory = 'select Id,CreatedById,Machine_Number__c,Machine_Number__r.Last_Service_Date__c,Machine_Number__r.Preventing_M__c,Machine_Number__r.Name,Customer__c from Machine_Inventory__c where Status__c!=\'Ready\'';
        return Database.getQueryLocator(listOfMachinesInventory);
    }
    global void execute(Database.BatchableContext bc, List<Machine_Inventory__c> listOfMachinesInventory)
    {
        Set <Id> instanceIds = new Set<Id>();
        //System.debug('Rachit');
        List<Case> listOfCase = new List<Case>();
        List<Case> listOfOpencases = [select Machine_Inventory__r.Id,Id,Reason from Case where IsClosed = false];//and reason=service due
        Map<Id,Case> mapOfInventoryIdNOpenCase = new Map<Id,Case>();
        for(Case instanceOfCase:listOfOpencases)
        {
            mapOfInventoryIdNOpenCase.put(instanceOfCase.Machine_Inventory__r.Id,instanceOfCase);
        }
        for(Machine_Inventory__c instance:listOfMachinesInventory)
        {
            instanceIds=mapOfInventoryIdNOpenCase.keyset();
            //System.debug(instance.Machine_Number__r.Last_Service_Date__c.daysbetween(date.Today()));
            try
            {   
                if(instance.Machine_Number__r.Last_Service_Date__c!=null & instance.Machine_Number__r.Last_Service_Date__c.daysbetween(date.Today())>instance.Machine_Number__r.Preventing_M__c)
                {
                    if(instanceIds.contains(instance.id))
                    {
                        if(mapOfInventoryIdNOpenCase.get(instance.id).Reason!='Service Due')
                        {
                            Case caseInstance = new Case();
                            caseInstance.Machine_Inventory__c = instance.Id;
                            caseInstance.OwnerId = instance.CreatedById;//TBD
                            //caseInstance.ClosedDate = instance.Machine_Number__r.Last_Service_Date__c+150;Choose according to User
                            caseInstance.Status = 'Not Started';
                            caseInstance.Reason = 'Service Due';
                            caseInstance.Origin = 'Email';
                            caseInstance.Machine__c = instance.Machine_Number__c;
                            //caseInstance.Type = '';
                            //Either one of two - 
                            if(instance.Customer__c!=null||instance.Customer__c!='')
                            caseInstance.AccountId = instance.Customer__c;
                            else if(instance.Distributor__c!=null||instance.Distributor__c!='')
                            caseInstance.AccountId = instance.Distributor__c;
                            //Please clarify
                            caseInstance.Subject = 'Machine Due for Preventive Servicing';
                            caseInstance.Description = 'Machine Number : '+ instance.Machine_Number__r.Name +' is due for preventive servicing. Please follow up on the Machine Immediately.';
                            listOfCase.add(caseInstance);
                        }
                    }
                    else
                    {
                        Case caseInstance = new Case();
                        caseInstance.Machine_Inventory__c = instance.Id;
                        caseInstance.OwnerId = instance.CreatedById;//TBD
                        //caseInstance.ClosedDate = instance.Machine_Number__r.Last_Service_Date__c+150;Choose according to User
                        caseInstance.Status = 'Not Started';
                        caseInstance.Reason = 'Service Due';
                        caseInstance.Origin = 'Email';
                        caseInstance.Machine__c = instance.Machine_Number__c;
                        //caseInstance.Type = '';
                        caseInstance.AccountId = instance.Customer__c;
                        caseInstance.Subject = 'Machine Due for Preventive Servicing';
                        caseInstance.Description = 'Machine Number : '+ instance.Machine_Number__r.Name +' is due for preventive servicing. Please follow up on the Machine Immediately.';
                        listOfCase.add(caseInstance);
                    }
                }
                }
                catch(Exception e)
                {
                    
                }
                
        }
        database.insert(listOfCase);
    }
    global void finish(Database.BatchableContext bc)
    {
        
    }
}