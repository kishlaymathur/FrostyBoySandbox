trigger FB_Machine_Commision_Case_AI on Machine__c (after insert) 
{
	List<Case> listOfCases = new List<Case>();
	for(Machine__c machineInstance: Trigger.new)
	{
		Case instanceOfCase = new Case();
		instanceOfCase.Machine__c = machineInstance.Id;
		instanceOfCase.Reason = 'Machine Commissioning';
		instanceOfCase.Status = 'Not Started';
		instanceOfCase.Description = machineInstance.Name+' needs to Commisioned. Please start with this as soon as possible.';
		listOfCases.add(instanceOfCase);
	}
	database.insert(listOfCases);
}