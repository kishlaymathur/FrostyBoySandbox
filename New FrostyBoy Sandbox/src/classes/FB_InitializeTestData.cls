global class FB_InitializeTestData
{
    public static Lead createLead()
    {
        Lead testLead = new Lead();
        testLead.LastName = 'LastName';
        testLead.Company = 'Company';
        return testLead;
    }
    public static Account createAccount(String testAccountName)
    {
        Account testAccount = new Account();
        testAccount.Name = testAccountName;
        return testAccount;
    }
    public static Opportunity createOpportunity(String testOpportunityName, Id testAccountId)
    {
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.Name = testOpportunityName;
        testOpportunity.AccountId = testAccountId;
        testOpportunity.CloseDate = date.today();
        testOpportunity.StageName = 'Closed Won';
        testOpportunity.Product_Group__c = 'Beverages';
        testOpportunity.TotalOpportunityQuantity = 10000;
        testOpportunity.LeadSource = 'Cold Calling';
        testOpportunity.Description = 'Abc Def Ghi Jkl Mno Pqrs Tuv Wxyz';
        return testOpportunity;
    }
    public static Campaign createCampaign(String testCampaignName)
    {
        Campaign testCampaign = new Campaign();
        testCampaign.Name = testCampaignName;
        return testCampaign;
    }
    public static Account_Campaign_Member__c createAccountCampaignMember(String accId,String campaignId)
    {
        Account_Campaign_Member__c testACM = new Account_Campaign_Member__c();
        testACM.Campaign__c = campaignId;
        testACM.Account__c = accId;
        return testACM;
    }
    public static Machine__c createMachine(String machineSerial)
    {
        Machine__c testMachine = new Machine__c();
        testMachine.Name = machineSerial;
        testMachine.Preventing_M__c = 150;
        testMachine.Model_Type__c = 'Smach 1500';
        testMachine.Machine_Decals__c = 'Generic';
        testMachine.Last_Service_Date__c = date.newinstance(2013,01,16);
        testMachine.RecordTypeId =[select id,name from recordtype where sobjecttype='Machine__c' and name='Machine'].id;
        return testMachine;
    }
    public static Machine_Inventory__c createMachineInventory(String machineId,Id customerId)
    {
        Machine_Inventory__c testMachineInventory = new Machine_Inventory__c();
        testMachineInventory.Machine_Number__c = machineId;
        testMachineInventory.Status__c = 'Allocated';
        testMachineInventory.Customer__c = customerId;
        return testMachineInventory;
    }
    public static Monthly_Payment__c createMonthlyPayments(String machineInventoryId,String paymentName)
    {
        Monthly_Payment__c testMonthlyPayment = new Monthly_Payment__c();
        testMonthlyPayment.Name = paymentName;
        testMonthlyPayment.Machine_Location__c = machineInventoryId;
        testMonthlyPayment.Expected_Rent__c = 50.00;
        testMonthlyPayment.Actual_Rent__c = 60.00;
        testMonthlyPayment.Month__c = Date.today();
        return testMonthlyPayment;
    }
    public static Case createCase(Id inventoryId)
    {
        Case testCase = new Case();
        testCase.Machine_Inventory__c = inventoryId;
        testCase.Status='Not Started';
        testCase.Origin='Email';
        return testCase;
    }
    public static Case createCase()
    {
        Case testCase = new Case();
        testCase.Status='Not Started';
        testCase.Origin='Email';
        return testCase;
    }
    public static Purchase__c createPurchase(String SparePartId){
        Purchase__c testPurchase=new Purchase__c();
        testPurchase.Machine__c=SparePartId;
        testPurchase.Quantity__c=50;
        return testPurchase;
    }
    public static Task createTask(String whatId)
    {
    Task testTask = new Task();
    testTask.Subject= 'Call';
    testTask.WhatId= whatId;
    testTask.Description = 'Description';
    testTask.ActivityDate = date.today();
    testTask.Follow_up_Comments__c = 'abc';
    return testTask;
    }
    
    
}