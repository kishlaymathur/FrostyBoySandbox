public class FB_TriggerHandler_Case_TestClass 
{
	private static Account testAccount;
	private static Case testCase;
	private static Machine__c testMachine;
	private static Machine_Inventory__c testMachineLocation;
	private static void init()
	{
		testAccount = FB_InitializeTestData.createAccount('TestAccount');
		testAccount.Type = 'Machine Customer';
		database.insert(testAccount);
		testCase = FB_InitializeTestData.createCase();
		database.insert(testCase);
		testMachine = FB_InitializeTestData.createMachine('R12333');
		database.insert(testMachine);
		testMachineLocation = FB_InitializeTestData.createMachineInventory(testMachine.Id,testAccount.Id);
		database.insert(testMachineLocation);
	}
	private static testMethod void CaseTriggerOnClose()
	{
		init();
		Test.starttest();
		testCase.Reason = 'Machine Commissioning';
        testCase.Status='Completed';
        testCase.Machine__c = testMachine.Id;
        database.update(testCase);
        Test.stoptest();
        Machine__c machIn = [select Commissioned__c from Machine__c where Id=:testMachine.Id];
        System.assertEquals(machIn.Commissioned__c, true);
	}
	private static testMethod void CaseTriggerRollupOnUpdate()
	{
		init();
		Test.starttest();
		Machine_Inventory__c machInvIn1 = [select Revenue_Till_Date__c,Cost_Till_date__c from Machine_Inventory__c where Id=:testMachineLocation.Id];
		testCase.Reason = 'Service Due';
        //testCase.Status='Completed';
        testCase.Machine_Inventory__c = testMachineLocation.Id;
        testCase.Cost__c = 5;
        testCase.Revenue__c = 10;
        database.update(testCase);
        Test.stoptest();
        Machine_Inventory__c machInvIn2 = [select Revenue_Till_Date__c,Cost_Till_date__c from Machine_Inventory__c where Id=:testMachineLocation.Id];
        System.assertNotEquals(machInvIn1.Revenue_Till_Date__c, machInvIn2.Revenue_Till_Date__c);
        System.assertNotEquals(machInvIn1.Cost_Till_date__c, machInvIn2.Cost_Till_date__c);
	}
}