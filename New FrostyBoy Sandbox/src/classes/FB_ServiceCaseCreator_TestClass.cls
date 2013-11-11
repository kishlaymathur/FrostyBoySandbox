@isTest(seeAllData=false)
private class FB_ServiceCaseCreator_TestClass 
{
	private static Account testAccount;
	private static Machine__c machInstance;
	private static Machine_Inventory__c machInvInstance;
	private static List<Machine__c> listOfMachines;
	private static List<Machine_Inventory__c> listOfMachineLocation;
	private static List<Case> listOfCases;
	private static void init()
	{
		testAccount = FB_InitializeTestData.createAccount('FrostyBoyTestAccount');
		testAccount.Type = 'Machine Customer';
		database.insert(testAccount);
		listOfMachines = new List<Machine__c>();
		for(Integer i=0;i<10;i++)
		{
			Machine__c testMachine = FB_InitializeTestData.createMachine('M-'+i);
			listOfMachines.add(testMachine);
		}
		database.insert(listOfMachines);
		listOfMachineLocation = new List<Machine_Inventory__c>();
		for(Machine__c instanceOfMachine:listOfMachines)
		{
			Machine_Inventory__c testMachineInventory = FB_InitializeTestData.createMachineInventory(instanceOfMachine.Id,testAccount.Id);
			listOfMachineLocation.add(testMachineInventory);
		}
		database.insert(listOfMachineLocation);
		
		
	}
	private static testMethod void testCreateCases()
	{
		init();
		Test.starttest();
        FB_ServiceCaseCreator batchApex = new FB_ServiceCaseCreator();
        ID batchprocessid= Database.executeBatch(batchApex); 
        Test.stoptest();
	}
	private static testMethod void testCreateCases2()
	{
		init();
		listOfCases = new List<Case>();
		for(Machine_Inventory__c instanceOfMachineInventory:listOfMachineLocation)
		{
			Case testCase = FB_InitializeTestData.createCase(instanceOfMachineInventory.Id);
			testCase.Reason = 'New Problem';
			listOfCases.add(testCase);
		}
		database.insert(listOfCases);
		Test.starttest();
        FB_ServiceCaseCreator batchApex = new FB_ServiceCaseCreator();
        ID batchprocessid= Database.executeBatch(batchApex); 
        Test.stoptest();
	}
	
}