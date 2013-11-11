@isTest(seeAlldata = true)
private class FB_SendOppEmail_TestClass
{
    static Account parentAccount;
    static Account childAccount;
    static Opportunity childAccountOpportunity;

public static void init()
{
   parentAccount = FB_InitializeTestData.createAccount('ParentAccount');
   parentAccount.Type = 'Distributor';   
   parentAccount.Primary_Email__c = 'Name@Company.com';
   database.insert(parentAccount);
   childAccount = FB_InitializeTestData.createAccount('ChildAccount');
   childAccount.ParentId = parentAccount.Id;
   database.insert(childAccount);
   childAccountOpportunity = FB_InitializeTestData.createOpportunity('ChildAccountOpportunity',childAccount.Id);
   database.insert(childAccountOpportunity);
}
static testmethod void testCaseSimple()
{
    init();
    NotifyOpportunity.SendNotificationMail(childAccountOpportunity.Id);
}

}