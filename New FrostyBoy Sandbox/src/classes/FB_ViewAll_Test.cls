@isTest
private class FB_ViewAll_Test
{
    static Account testAccount;
    static Task testTask;
    public static void init()
    {
        testAccount = FB_InitializeTestData.createAccount('TestAccount');
        database.insert(testAccount);
        testTask = FB_InitializeTestData.createTask(testAccount.Id);
        database.insert(testTask);
    }
    static testmethod void testMethod1()
    {
        init();
        Test.startTest();
        PageReference pg = new PageReference('/apex/FB_CustomViewAll?id='+testAccount.Id);
        FB_ViewAllController controller = new FB_ViewAllController();
        controller.getTasks();
        controller.Cancel();
        Test.stopTest();
    }
}