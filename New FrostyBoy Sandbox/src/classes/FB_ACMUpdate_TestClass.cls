@isTest
private class FB_ACMUpdate_TestClass
{    
    static Account testAccount;
    static Campaign testCampaign;
    static Account_Campaign_Member__c testACM;
    public static void init()    
    {
        testCampaign = FB_InitializeTestData.createCampaign('Summer Trade Show');
        database.insert(testCampaign);
        testAccount = FB_InitializeTestData.createAccount('Yoghurt');
        testAccount.Account_Status__c = 'Lead';
        database.insert(testAccount);
        testACM = FB_InitializeTestData.createAccountCampaignMember(testAccount.Id,testCampaign.Id);
        testACM.Account_Status1__c = 'Lead';
        database.insert(testACM);
    }
    static testmethod void testCase()
    {
        init();
        Test.StartTest();
        testAccount.Account_Status__c = 'Active';
        database.update(testAccount);
        Test.StopTest();
    }
}