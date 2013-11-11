@isTest(seealldata=false)
private class FB_RollUpQuantityAndCost_TestClass {
	private static case caseInstance;
	private static Machine__c machine,sparePart;
	private static Machine_inventory__c inventory;
	private static Account customer;
	private static FB_AddSparePartsController controller;
	private static Spare_Parts_used__c sparePartUsed;
	private static List<Purchase__c> testPurchaseList;
	static void init(){
        testPurchaseList=new List<purchase__c>();
        sparePartUsed=new Spare_Parts_used__c();
       customer=FB_InitializeTestData.createAccount('TestCustomer');
		customer.type='Machine Customer';
		database.insert(customer);
		 machine=FB_InitializeTestData.createMachine('TEST128766');
		 database.insert(machine);
		 inventory=FB_InitializeTestData.createMachineInventory(machine.id,customer.id);
		 database.insert(inventory);
		caseInstance=FB_InitializeTestData.createCase(inventory.id);
		database.insert(caseInstance);
		controller=new FB_AddSparePartsController(new ApexPages.StandardController(caseInstance));
		
		 sparePart=FB_InitializeTestData.createMachine('TEST1233');
		 sparePart.RecordTypeId =[select id,name from recordtype where sobjecttype='Machine__c' and name='Spare Part'].id;
		 database.insert(sparePart);
        for(integer i=0;i<10;i++){
            Purchase__c newPurchase=FB_InitializeTestData.createPurchase(sparePart.id);
            newPurchase.Unit_Price__c=50;
            testPurchaseList.add(newPurchase);            
        }
		database.insert(testPurchaseList);	
		sparePartUsed=new Spare_Parts_used__c();
		sparePartUsed.Case__c=caseInstance.id;
		sparePartUsed.Spare_Part__c=sparePart.id;
		sparePartUsed.Quantity__c=0;		
		database.insert(sparePartUsed);
    }
    static testMethod void myUnitTest() {
        Test.startTest();
        init();            
        Test.stopTest();
    }
}