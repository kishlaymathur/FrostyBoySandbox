@isTest(seeAlldata = false)
private class FB_StateMap_TestClass
{
    static Account Account1;
    static Account Account2;
    static Account Account3;

    public static void init()
    {
        Account1 = FB_InitializeTestData.createAccount('Account1');
        Account1.Type = 'Distributor';   
        Account1.Primary_Email__c = 'Name@Company.com';
        Account1.BillingStreet = '70 - 82 Burchill Street';
        Account1.BillingCity = 'Loganholme';
        Account1.BillingState = 'QLD';
        Account1.BillingPostalCode = '4129';
        Account1.BillingCountry = 'Australia';
        Account1.Account_Status__c = 'Active';
        database.insert(Account1);
        Account2 = FB_InitializeTestData.createAccount('Account2');
        Account2.Type = 'Distributor';   
        Account2.Primary_Email__c = 'Name@Company.com';
        Account2.BillingStreet = '159 William St';
        Account2.BillingCity = 'Brisbane';
        Account2.BillingState = 'Qld';
        Account2.BillingPostalCode = '4000';
        Account2.BillingCountry = 'Australia';
        Account2.Account_Status__c = 'Active';
        database.insert(Account2);
        Account3 = FB_InitializeTestData.createAccount('Account3');
        Account3.Type = 'Distributor';   
        Account3.Primary_Email__c = 'Name@Company.com';
        Account3.BillingStreet = 'Pacific Motorway';
        Account3.BillingCity = 'Oxenford';
        Account3.BillingState = 'Qld';
        Account3.BillingPostalCode = '4210';
        Account3.BillingCountry = 'Australia';
        Account3.Account_Status__c = 'Active';
        database.insert(Account3);
    }
    static testmethod void testCase1()
    {
        init();
        PageReference pg = new PageReference('/apex/FB_MapsByFilter');
        Test.setCurrentPageReference(pg);
        FB_MapsByFilterController controller = new FB_MapsByFilterController();
        controller.getItems();
        controller.Go();
        FB_MapsByFilterController.getAddresses('QLD',true,true,true);
        
    }
}