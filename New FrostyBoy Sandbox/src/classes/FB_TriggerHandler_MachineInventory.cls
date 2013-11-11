public class FB_TriggerHandler_MachineInventory 
{
		private static FB_TriggerHandler_MachineInventory instance;
		public static FB_TriggerHandler_MachineInventory getInstance()
		{
			if (instance == null) instance = new FB_TriggerHandler_MachineInventory();
        return instance;
		}
		//-- PUBLIC METHODS
		public void onBeforeInsert(final List<Machine_Inventory__c> newObjects) 
		{
			this.invntryValdatnBI(newObjects);
		}
		public void onBeforeUpdate(final List<Machine_Inventory__c> oldObjects, final Map<Id, Machine_Inventory__c> oldObjectsMap,
                               final List<Machine_Inventory__c> newObjects, final Map<Id, Machine_Inventory__c> newObjectsMap) 
                               {
                               	this.invntryValdatnBU(newObjects,oldObjectsMap);
                               }
        public void onAfterUpdate(final List<Machine_Inventory__c> oldObjects, final Map<Id, Machine_Inventory__c> oldObjectsMap,
                              final List<Machine_Inventory__c> newObjects, final Map<Id, Machine_Inventory__c> newObjectsMap) 
                              {
                              	this.genratMnthlPaymntfrInactvInvntry(newObjects,oldObjectsMap);
                              }
		public void onAfterInsert(final List<Machine_Inventory__c> newObjects, final Map<Id, Machine_Inventory__c> newObjectsMap)
		{
			
		}
		//--PRIVATE METHODS
		private Map<Id,Machine_Inventory__c> invntryValdatn(final List<Machine_Inventory__c> newObjects)
		{
			List<Id> listOfMachineId = new List<Id>();
		    Map<Id,Machine_Inventory__c> mapOfMachineIdNdName = new Map<Id,Machine_Inventory__c>();//id_name
		    for(Machine_Inventory__c machineInventoryInstance:newObjects)
		    {        
		        listOfMachineId.add(machineInventoryInstance.Machine_Number__c);     
		    }
		    //List<Machine_Inventory__c> duplicateAllocatedMachineInventory = ;
		    for(Machine_Inventory__c instanceMI:[select Machine_Number__c,Id,Name,Status__c from Machine_Inventory__c where Machine_Number__c IN:listOfMachineId AND Status__c!='Ready' order by Contract_End_Date__c desc])
		    {
		        mapOfMachineIdNdName.put(instanceMI.Machine_Number__c,instanceMI);
		    }
		    return mapOfMachineIdNdName;
		}
		private void invntryValdatnBU(final List<Machine_Inventory__c> newObjects,final Map<Id, Machine_Inventory__c> oldObjectsMap)
		{
			Map<Id,Machine_Inventory__c> mapOfMachineIdNdName = this.invntryValdatn(newObjects);
			for(Machine_Inventory__c machineInventoryInstance:newObjects)
    		{
    			/*if(mapOfMachineIdNdName.containsKey(machineInventoryInstance.Machine_Number__c) && (mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)).Name==machineInventoryInstance.Name)//Removing that particular instance out.
         		{
         			System.debug(mapOfMachineIdNdName.remove(machineInventoryInstance.Machine_Number__c));
         			Machine_Inventory__c removeUpdateInstance = mapOfMachineIdNdName.remove(machineInventoryInstance.Machine_Number__c);//removing itself from list to make sure errors dont pop while changing to status repair, allocatedcooloff.
         		}*/
         		System.debug('Checkpoint 1');
         		if(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)!=null)
     			{
	         		System.debug(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)+'abcd');
		            if(machineInventoryInstance.Status__c!=oldObjectsMap.get(machineInventoryInstance.Id).Status__c)
		            {
		                System.debug('in');
		                if((mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)).Id!=machineInventoryInstance.Id)
		                {
			                if(machineInventoryInstance.Status__c == 'Allocated'||machineInventoryInstance.Status__c == 'Repair'||machineInventoryInstance.Status__c == 'Allocated-Cool Off')
			                machineInventoryInstance.addError('The Machine already have '+(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)).Status__c+' Inventory Record at location '+(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)).Name);
		                }
		            }   
         		}
    		}       
		}
		private void invntryValdatnBI(final List<Machine_Inventory__c> newObjects)
		{
			Map<Id,Machine_Inventory__c> mapOfMachineIdNdName = this.invntryValdatn(newObjects);
			for(Machine_Inventory__c machineInventoryInstance:newObjects)
    		{
    			if(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)!=null && (machineInventoryInstance.Status__c == 'Allocated'||machineInventoryInstance.Status__c == 'Repair'||machineInventoryInstance.Status__c == 'Allocated-Cool Off'))
         		{
            		machineInventoryInstance.addError('The Machine already have '+(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)).Status__c+' Inventory Record at location '+(mapOfMachineIdNdName.get(machineInventoryInstance.Machine_Number__c)).Name);
         		}
    		}
		}
		private void genratMnthlPaymntfrInactvInvntry(final List<Machine_Inventory__c> newObjects,final Map<Id, Machine_Inventory__c> oldObjectsMap)
		{
			List<String> machineLocationIds=new List<String>();
      		for(Machine_Inventory__c machineLocation:newObjects)
      		{
	      		//System.debug(MachineLocation);
	      		if(machineLocation.Status__c=='Ready' && oldObjectsMap.get(machineLocation.id).status__c!='Ready')
	      		machineLocationIds.add(machineLocation.id);
      		}
      		if(!machineLocationIds.isEmpty())
      		FB_ClassGenerateMonthlyPayments.ExecuteGenerateMonthlyPayment(machineLocationIds,'Ready');
	      	//system.debug(machineLocationIds.size());
	      	
	      	Map<Id,Machine_Inventory__c> mapOfmachineIdAndStatus = new Map<Id,Machine_Inventory__c>();
	      	for(Machine_Inventory__c machineLocation:newObjects)
	      	{
	      		if(oldObjectsMap.get(machineLocation.id).status__c!=machineLocation.status__c && machineLocation.Contract_Start_Date__c<=date.today() && machineLocation.Contract_End_Date__c>=date.today())     		
	      		{
	      			mapOfmachineIdAndStatus.put(machineLocation.Machine_Number__c,machineLocation);
      			}
	      	}
	      	if(!mapOfmachineIdAndStatus.isEmpty())
	      	{
	      		for(Machine__c instanceOfMachine:[select Id from Machine__c where Id IN:mapOfmachineIdAndStatus.keyset()])
	      		{
	      			System.debug((mapOfmachineIdAndStatus.get(instanceOfMachine.Id)).Status__c+' -- New Checker On Machine Location Status');
	      			System.debug((mapOfmachineIdAndStatus.get(instanceOfMachine.Id)).Customer__c+' -- New Checker 2 On Machine Location Status');
	      			System.debug((mapOfmachineIdAndStatus.get(instanceOfMachine.Id)).DistributorId__c+' -- New Checker 2 On Machine Location Status');
	      			if((mapOfmachineIdAndStatus.get(instanceOfMachine.Id)).Status__c=='Allocated')
	      			{
	      				instanceOfMachine.Current_Machine_Location__c = (mapOfmachineIdAndStatus.get(instanceOfMachine.Id)).Customer__c;
	      			}
	      			else
	      			{
	      				System.Debug('in in in');
	      				instanceOfMachine.Current_Machine_Location__c = (mapOfmachineIdAndStatus.get(instanceOfMachine.Id)).DistributorId__c;
	      			}
	      			update instanceOfMachine;
	      		}
	      	}	
		}
		
}