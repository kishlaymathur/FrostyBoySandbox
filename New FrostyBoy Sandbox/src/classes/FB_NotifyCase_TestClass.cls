public class FB_NotifyCase_TestClass 
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
	    testMachine = FB_InitializeTestData.createMachine('R12333');
	    database.insert(testMachine);
	    testMachineLocation = FB_InitializeTestData.createMachineInventory(testMachine.Id,testAccount.Id);
	    database.insert(testMachineLocation);
	    testCase = FB_InitializeTestData.createCase(testMachineLocation.Id);
	    database.insert(testCase);
	}
	static testmethod void testSendMail()
	{
	    init();
	    Test.starttest();
	    String passString = FB_NotifyCase.sendEmailNotification(testCase.Id,'rachitcse0038@gmail.com','','Rachit');
	    Test.stoptest();
	    System.assertEquals(passString,'Success');
	    
	}
}