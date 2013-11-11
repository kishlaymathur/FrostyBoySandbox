trigger FB_Triggers_MachineInventory on Machine_Inventory__c (after insert, after update, before insert, 
before update) 
{
	//-- Instantiate the handler
	FB_TriggerHandler_MachineInventory handler = FB_TriggerHandler_MachineInventory.getInstance();

	//-- Before Insert
	if (Trigger.isInsert && Trigger.isBefore) {
		handler.onBeforeInsert(Trigger.new);
	} 

	//-- Before Update
	if (Trigger.isUpdate && Trigger.isBefore) {
		handler.onBeforeUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
	} 
	
	//-- After Update
	if (Trigger.isUpdate && Trigger.isAfter) {        
		handler.onAfterUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
	}
    /*
    // -- After Insert -- Not Included
    if (Trigger.isAfter && Trigger.isInsert) {        
		handler.onAfterInsert(Trigger.new,Trigger.newMap);
    }*/
}