trigger FB_Inventory_Validation_BI_BU on Machine_Inventory__c (before insert, before update) 
{
    System.debug('In trigger');
    List<Id> listOfMachineId = new List<Id>();
    Map<Id,Machine_Inventory__c> mapOfMachineIdNdName = new Map<Id,Machine_Inventory__c>();//id_name
    for(Machine_Inventory__c machineInventoryInstance:Trigger.new)
    {        
        listOfMachineId.add(machineInventoryInstance.Machine_Number__c);     
    }
    List<Machine_Inventory__c> duplicateAllocatedMachineInventory = [select Machine_Number__c,Id,Name,Status__c from Machine_Inventory__c where Machine_Number__c IN:listOfMachineId AND Status__c!='InAllocated'];
    for(Machine_Inventory__c instance:duplicateAllocatedMachineInventory)
    {
        mapOfMachineIdNdName.put(instance.Machine_Number__c,instance);
    }
    for(Machine_Inventory__c machineInventoryInstance:Trigger.new)
    {        
         System.debug(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c));
         if(Trigger.isUpdate) 
         {
            //System.debug(mapOfMachineIdNdName.containsKey(machineInventoryInstance.Machine_Number__c)+'Condition 1');
            //System.debug((mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)).Name+' Condition 2 = '+machineInventoryInstance.Name);
            if(mapOfMachineIdNdName.containsKey(machineInventoryInstance.Machine_Number__c) && (mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)).Name==machineInventoryInstance.Name)//Removing that particular instance out.
            {
                Machine_Inventory__c removeUpdateInstance = mapOfMachineIdNdName.remove(machineInventoryInstance.Machine_Number__c);
            }
            if(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)!=null)
            {
                System.debug(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)+'abcd');
                if(Trigger.oldMap.get(machineInventoryInstance.Id).Status__c!= machineInventoryInstance.Status__c || Trigger.oldMap.get(machineInventoryInstance.Id).Machine_Number__c!= machineInventoryInstance.Machine_Number__c )
                {
                    System.debug('in');
                    if(machineInventoryInstance.Status__c == 'Allocated'||machineInventoryInstance.Status__c == 'Repair'||machineInventoryInstance.Status__c == 'Allocated-Cool Off')
                    machineInventoryInstance.addError('The Machine already have '+(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)).Status__c+' Inventory Record at location '+(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)).Name);
                }   
            }
            
         }
         if(Trigger.isInsert && mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)!=null && (machineInventoryInstance.Status__c == 'Allocated'||machineInventoryInstance.Status__c == 'Repair'||machineInventoryInstance.Status__c == 'Allocated-Cool Off'))
         {
            machineInventoryInstance.addError('The Machine already have '+(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)).Status__c+' Inventory Record at location '+(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)).Name);
         }
    }
    
     
}