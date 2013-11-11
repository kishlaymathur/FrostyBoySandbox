public class FB_TriggerHandler_Case 
{
	private static FB_TriggerHandler_Case instance;
	static Map<Id,Machine_Inventory__c> machineInventoryMap;
    public static FB_TriggerHandler_Case getInstance() 
    {	
    	if (instance == null) {
    		instance = new FB_TriggerHandler_Case();
    	machineInventoryMap=new Map<Id,Machine_Inventory__c>();
    	}
        return instance;
    }
  
	public void onAfterInsert(final List<Case> newObjects) 
	{
		this.rollupCostAndRevenueAI(newObjects);
	}
	
    public void onAfterUpdate(final List<Case> oldObjects, final Map<Id, Case> oldObjectsMap,
                              final List<Case> newObjects, final Map<Id, Case> newObjectsMap) 
                              {
                                  this.setComsndTrueOnCaseClose(newObjects, oldObjectsMap);
                                  this.rollupCostAndRevenueAU(newObjects,oldObjectsMap);
                              }
    

	
    
    private void setComsndTrueOnCaseClose(final List<Case> triggerList,final Map<Id, Case> triggerOldMap)
    {
    	List<Id> listOfMachineId = new List<id>();
    	for(Case instanceOfCase:triggerList)
    	{
  			//System.debug('in1');
	      	if(instanceOfCase.Reason=='Machine Commissioning')
      		{
	        	//System.debug('in2');
	        	if( triggerOldMap.get(instanceOfCase.id).Status!=instanceOfCase.Status && instanceOfCase.Status=='Completed')
	        	{
	          		//System.debug('Check in Case - '+instanceOfCase.Id+' Commisioned '+instanceOfCase.Machine__r.Commissioned__c);
	          		listOfMachineId.add(instanceOfCase.Machine__c);
	          
	        	}
	      	}
    	}
	    if(listOfMachineId!=null)
	    {
	        List<Machine__c> listToUpdate = new List<Machine__c>();
	        for(Machine__c mach:[select Commissioned__c from Machine__c where Id IN:listOfMachineId])
	        {
		        mach.Commissioned__c = true;
		        listToUpdate.add(mach);
	        }
	        database.update(listToUpdate);
        }
    
	}
	private Map<Id,Machine_Inventory__c> rollupCostAndRevenue(final List<Case> newObjects)
	{
		//Map<Id,Machine_Inventory__c> machineInventoryMap=new Map<Id,Machine_Inventory__c>();
		List<Id> machineInventoryIds=new List<Id>();
	    for(Case c:newObjects)
	    {
	    	if(c.Machine_Inventory__c!=null)
	    	machineInventoryIds.add(c.Machine_Inventory__c);
	    }
	    for(Machine_Inventory__c m:[select id,Revenue_till_date__c,cost_till_date__c from Machine_Inventory__c where id in:machineInventoryIds])
	    {
	    	machineInventoryMap.put(m.id,m);
	    }
	    return machineInventoryMap;
	}
	private void rollupCostAndRevenueAI(final List<Case> newObjects)    
	{
		if(machineInventoryMap.size()==0)
		machineInventoryMap = this.rollupCostAndRevenue(newObjects);
		List<Machine_Inventory__c> updatedMachineInventory=new List<Machine_Inventory__c>();
		Machine_Inventory__c machineInventory;
		for(Case c:newObjects)
		{
	    	if(c.Reason=='Service Due')
	    	{
		        Decimal revenue=0,cost=0;
		        //System.debug(c.Machine_Inventory__r.revenue_till_date__c);
		        revenue=machineInventoryMap.get(c.Machine_Inventory__c).revenue_till_date__c+c.Revenue__c;
		        cost=machineInventoryMap.get(c.Machine_Inventory__c).cost_till_date__c+c.Cost__c+c.Cost_incurred_on_Spare_Parts__c;
		        machineInventory=machineInventoryMap.get(c.Machine_Inventory__c);
		        machineInventory.revenue_till_date__c=revenue;
		        machineInventory.cost_till_date__c=cost;
		        updatedMachineInventory.add(machineInventory);
	    	}
		}
		if(updatedMachineInventory.size()!=0)
	    Database.update(updatedMachineInventory);
	 }	
	 private void rollupCostAndRevenueAU(final List<Case> newObjects,final Map<Id, Case> oldObjectsMap)    
	{
		if(machineInventoryMap.size()==0)
		machineInventoryMap = this.rollupCostAndRevenue(newObjects);
		List<Machine_Inventory__c> updatedMachineInventory=new List<Machine_Inventory__c>();
		Machine_Inventory__c machineInventory;
		for(Case c:newObjects)
		{
	    	if(c.Reason=='Service Due')
	    	{
		        Decimal revenue=0,cost=0;
		        if(oldObjectsMap.get(c.id).revenue__c!= c.Revenue__c || oldObjectsMap.get(c.id).Cost__c !=c.Cost__c||oldObjectsMap.get(c.id).Cost_incurred_on_Spare_Parts__c!=c.Cost_incurred_on_Spare_Parts__c)
		        {
		        	//System.debug(machineInventoryMap.get(c.Machine_Inventory__c).revenue_till_date__c);
		        	revenue=machineInventoryMap.get(c.Machine_Inventory__c).revenue_till_date__c-oldObjectsMap.get(c.id).revenue__c+c.revenue__c;
		            cost=machineInventoryMap.get(c.Machine_Inventory__c).cost_till_date__c-oldObjectsMap.get(c.id).cost__c-oldObjectsMap.get(c.id).Cost_incurred_on_Spare_Parts__c+c.cost__c+c.Cost_incurred_on_Spare_Parts__c;
	        	}
		        machineInventory=machineInventoryMap.get(c.Machine_Inventory__c);
		        machineInventory.revenue_till_date__c=revenue;
		        machineInventory.cost_till_date__c=cost;
		        updatedMachineInventory.add(machineInventory);
	    	}
		}
		if(updatedMachineInventory.size()!=0)
	    Database.update(updatedMachineInventory);
	 }
}