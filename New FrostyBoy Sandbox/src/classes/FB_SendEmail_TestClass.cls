@isTest(seeAlldata = true)
private class FB_SendEmail_TestClass
{
    static Account parentAccount;
    static Account childAccount;

public static void init()
{
   parentAccount = FB_InitializeTestData.createAccount('ParentAccount');
   parentAccount.Type = 'Distributor';   
   parentAccount.Primary_Email__c = 'Name@Company.com';
   database.insert(parentAccount);
   childAccount = FB_InitializeTestData.createAccount('ChildAccount');
   childAccount.ParentId = parentAccount.Id;
   database.insert(childAccount);
   Contact con = new Contact();
   con.LastName = 'Test Contact';
   con.AccountId = childAccount.Id;
   database.insert(con);
}
static testmethod void testCaseSimple()
{
    init();
    NotifyAccount.sendEmailNotification(childAccount.Id);
}

}