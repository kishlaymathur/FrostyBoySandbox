@isTest(seeAlldata = true)
public class FB_ConvertLead_TestClass
{
    static Lead childLead;
    static Account parentAccount;
    static Account childAccount;
    public static void init()
    {
        parentAccount = FB_InitializeTestData.createAccount('ParentAccount');
        parentAccount.Type = 'Distributor';   
        parentAccount.Primary_Email__c = 'Name@Company.com';
        database.insert(parentAccount);
        childLead = FB_InitializeTestData.createLead();
        childLead.Parent_Account__c = parentAccount.Id;
        childLead.Email = 'Lead@Company.com';
        childLead.Description = 'ABC';
        database.insert(childLead);
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(childLead .id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Lead');
        Database.LeadConvertResult lcr = Database.convertLead(lc);
               
    }
    static testmethod void testCaseSimple()
    {
        init();
    }
}