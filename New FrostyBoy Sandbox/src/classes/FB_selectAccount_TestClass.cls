@isTest
private class FB_selectAccount_TestClass
{
    static Account testAccount;
    static Campaign testCampaign1;
    static Campaign testCampaign2;
    public static List<Account> listOfTestAccount{get;set;}
    public static void init()
    {
        listOfTestAccount = new List<Account>();
        for(Integer i=0;i<30;i++)
        {
            testAccount = FB_InitializeTestData.createAccount('Company'+String.valueof(i+1));
            testAccount.Type = 'Customer';
            testAccount.Machine_Invoice_Number__c = 11+i;
            listOfTestAccount.add(testAccount);
            database.insert(testAccount);
        }
        testCampaign1 = FB_InitializeTestData.createCampaign('Summer Trade Show');
        database.insert(testCampaign1);
        testCampaign2 = FB_InitializeTestData.createCampaign('Winter Trade Show');
        database.insert(testCampaign2);
        //System.assertEquals(listOfTestAccount,null);
    }
    static testmethod void testcase()
    {
        init();
        Test.StartTest();
        PageReference pg = new PageReference('/apex/FB_SelectAccounts?fieldName=type&fieldType=PICKLIST&id='+testCampaign1.Id+'&operator=%3D&value=Customer');
        Test.setCurrentPageReference(pg);
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(listOfTestAccount);
        FB_selectAccountsController controller = new FB_selectAccountsController();
        //controller.getAccounts();
        controller.submissionList = controller.getAccounts();
        controller.next();
        controller.previous();
        controller.last();
        controller.first();
        controller.submissionList[0].isChecked = true;
        controller.submissionList[5].isChecked = true;
        controller.submissionList[7].isChecked = true;
        controller.submissionList[9].isChecked = true;
        controller.next();
        controller.submit();
        List<Account_Campaign_Member__c> listOfACM= [select Id,Account__c from Account_Campaign_Member__c where Campaign__c=:testCampaign1.Id];
        System.assertEquals(listOfACM.size(),4);
        Test.StopTest();
    }
    static testmethod void testcase1()//Filter Type - Integer,Double or Currency
    {
        init();
        Test.StartTest();
        PageReference pg = new PageReference('/apex/FB_SelectAccounts?fieldName=machine_invoice_number__c&fieldType=DOUBLE&id='+testCampaign2.Id+'&operator=%3D&value=11');
        Test.setCurrentPageReference(pg);
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(listOfTestAccount);
        FB_selectAccountsController controller = new FB_selectAccountsController();
        //controller.getAccounts();
        controller.submissionList = controller.getAccounts();
        controller.next();
        controller.previous();
        controller.last();
        controller.first();
        controller.submissionList[0].isChecked = true;
        controller.next();
        controller.submit();
        List<Account_Campaign_Member__c> listOfACM= [select Id,Account__c from Account_Campaign_Member__c where Campaign__c=:testCampaign2.Id];
        System.assertEquals(listOfACM.size(),1);
        Test.StopTest();
    }
}