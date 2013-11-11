public class FB_TriggerHandler_MI_TestClass 
{
	private static Account testAccount;
	private static Account testAccount2;
	private static Machine__c testMachine;
	private static Machine_Inventory__c testMachineInventory;
	private static Machine_Inventory__c testMachineInventory2;
	private static void init()
	{
		testAccount = FB_InitializeTestData.createAccount('FrostyBoyTestAccount');
		testAccount.Type = 'Machine Customer';
		database.insert(testAccount);
		testAccount2 = FB_InitializeTestData.createAccount('FrostyBoyTestAccount2');
		testAccount2.Type = 'Machine Customer';
		database.insert(testAccount2);
		testMachine = FB_InitializeTestData.createMachine('testMachine');
		database.insert(testMachine);
		testMachineInventory = FB_InitializeTestData.createMachineInventory(testMachine.Id,testAccount.Id);
		database.insert(testMachineInventory);
	}
	private static testMethod void insrtValdatnTestClassBI()
	{
		init();
		Test.starttest();
        try
        {
        	testMachineInventory2 = new Machine_Inventory__c();
	        testMachineInventory2.Machine_Number__c = testMachine.Id;
	        testMachineInventory2.Status__c = 'Allocated';
	        testMachineInventory2.Customer__c = testAccount2.Id;
	        database.insert(testMachineInventory2);
        }
        catch(Exception e)
        {
        	System.debug('PASS');
        }
        Test.stoptest();
	}
	private static testMethod void insrtValdatnTestClassBU()
	{
		init();
		Test.starttest();
        try
        {
        	testMachineInventory2 = new Machine_Inventory__c();
	    	testMachineInventory2.Machine_Number__c = testMachine.Id;
	        testMachineInventory2.Status__c = 'Ready';
	        testMachineInventory2.Customer__c = testAccount2.Id;
	        database.insert(testMachineInventory2);
        	testMachineInventory2.Status__c = 'Allocated';
        	database.update(testMachineInventory2);
        }
        catch(Exception e)
        {
        	System.debug('PASS2');
        }
        Test.stoptest();
	}
	private static testMethod void genMonthlPaymInactvTest()
	{
		init();
		Test.starttest();
		testMachineInventory.Status__c = 'Ready';
		database.update(testMachineInventory);
		Test.stoptest();
		
	}
}