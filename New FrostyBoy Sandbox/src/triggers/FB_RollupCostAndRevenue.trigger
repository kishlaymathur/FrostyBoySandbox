trigger FB_RollupCostAndRevenue on Case (after insert, after update) {
	
	/*Map<id,Machine_Inventory__c> machineInventoryMap=new Map<Id,Machine_Inventory__c>();
	List<Machine_Inventory__c> updatedMachineInventory=new List<Machine_Inventory__c>();
    Machine_Inventory__c machineInventory;
    List<Id> machineInventoryIds=new List<Id>();
    for(Case c:trigger.new){
    	machineInventoryIds.add(c.Machine_Inventory__c);
    }
    for(Machine_Inventory__c m:[select id,Revenue_till_date__c,cost_till_date__c from Machine_Inventory__c where id in:machineInventoryIds]){
    	machineInventoryMap.put(m.id,m);
    }
    
    for(Case c:trigger.new){
    	if(c.Reason=='Service Due')
    	{
	        Decimal revenue=0,cost=0;
	        if(trigger.isAfter && trigger.isInsert){
	            //System.debug(c.Machine_Inventory__r.revenue_till_date__c);
	            revenue=machineInventoryMap.get(c.Machine_Inventory__c).revenue_till_date__c+c.Revenue__c;
	            cost=machineInventoryMap.get(c.Machine_Inventory__c).cost_till_date__c+c.Cost__c+c.Cost_incurred_on_Spare_Parts__c;
	        }else 
	         
	        {
	        	if(trigger.oldMap.get(c.id).revenue__c!= c.Revenue__c || trigger.oldMap.get(c.id).Cost__c !=c.Cost__c||trigger.oldMap.get(c.id).Cost_incurred_on_Spare_Parts__c!=c.Cost_incurred_on_Spare_Parts__c){
	        		
	           //System.debug(machineInventoryMap.get(c.Machine_Inventory__c).revenue_till_date__c);
	            revenue=machineInventoryMap.get(c.Machine_Inventory__c).revenue_till_date__c- trigger.oldMap.get(c.id).revenue__c+c.revenue__c;
	            cost=machineInventoryMap.get(c.Machine_Inventory__c).cost_till_date__c-trigger.oldMap.get(c.id).cost__c-trigger.oldMap.get(c.id).Cost_incurred_on_Spare_Parts__c+c.cost__c+c.Cost_incurred_on_Spare_Parts__c;
	        	}
	        }
	        machineInventory=machineInventoryMap.get(c.Machine_Inventory__c);
	        machineInventory.revenue_till_date__c=revenue;
	        machineInventory.cost_till_date__c=cost;
	        updatedMachineInventory.add(machineInventory);
    	}
    }
    if(updatedMachineInventory.size()!=0)
    Database.update(updatedMachineInventory);
    //Rachit 27/08/2013
    public List<Id> listOfMachineId = new List<id>();
    for(Case instanceOfCase:trigger.new)
    {
    	System.debug('in1');
    	if(instanceOfCase.Reason=='Machine Commissioning' && trigger.isUpdate)
    	{
    		System.debug('in2');
    		if( trigger.oldMap.get(instanceOfCase.id).isClosed!=instanceOfCase.isClosed && instanceOfCase.isClosed==true)
    		{
    			System.debug('Check in Case - '+instanceOfCase.Id+' Commisioned '+instanceOfCase.Machine__r.Commissioned__c);
    			listOfMachineId.add(instanceOfCase.Machine__c);
    			
    		}
    	}
    		
    }
    if(trigger.isUpdate && listOfMachineId!=null)
    {
    	List<Machine__c> listToUpdate = new List<Machine__c>();
    	for(Machine__c mach:[select Commissioned__c from Machine__c where Id IN:listOfMachineId])
		{
			mach.Commissioned__c = true;
			listToUpdate.add(mach);
		}
		database.update(listToUpdate);
    }*/
    
    
    	//-- Instantiate the handler
	FB_TriggerHandler_Case handler = FB_TriggerHandler_Case.getInstance();

	//-- Before Insert
	//if (Trigger.isInsert && Trigger.isBefore) {
		//handler.onBeforeInsert(Trigger.new);
	//} else

	//-- Before Update
	//if (Trigger.isUpdate && Trigger.isBefore) {
	//	handler.onBeforeUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
	//} else
	
	//-- Before Delete
	//if (Trigger.isDelete && Trigger.isBefore) {
	//	handler.onBeforeDelete(Trigger.old, Trigger.oldMap);
	//} else
	
	//-- After Update
	if (Trigger.isUpdate && Trigger.isAfter) {        
		handler.onAfterUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
	}
    
    // -- After Insert
    if(Trigger.isInsert && Trigger.isAfter) {
    	handler.onAfterInsert(Trigger.new);
    }
    
	
}