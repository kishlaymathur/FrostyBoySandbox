@isTest
private class FB_CreateFilterController_TestClass
{    
    static Campaign testCampaign;
    public static void init()    
    {
        testCampaign = FB_InitializeTestData.createCampaign('Summer Trade Show');
        database.insert(testCampaign);
    }
    static testmethod void testCase()
    {
        init();
        Test.StartTest();
        PageReference pg = new PageReference('/apex/FB_CreateFilterCriteria?id='+testCampaign.Id);
        Test.setCurrentPageReference(pg);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCampaign);
        FB_CreateFilterCriteriaController controller = new FB_CreateFilterCriteriaController(sc);
        controller.getFields();
        controller.getOperators();
        controller.selectedValueField = 'Name';
        controller.selectedValueOperator = '=';
        controller.selectedValue = 'Derp';
        controller.Go();
        System.assertEquals('/apex/FB_SelectAccounts?fieldName=Name&operator==&value=Derp&fieldType=STRING&id='+testCampaign.Id,controller.pageRedirect);
        Test.StopTest();
    }
}