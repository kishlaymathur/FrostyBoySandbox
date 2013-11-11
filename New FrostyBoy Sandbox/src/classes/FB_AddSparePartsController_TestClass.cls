@isTest(seealldata=false)
private class FB_AddSparePartsController_TestClass {
	private static case caseInstance;
	private static Machine__c machine,sparePart;
	private static Machine_inventory__c inventory;
	private static Account customer;
	private static FB_AddSparePartsController controller;
	private static Spare_Parts_used__c sparePartUsed;
	private static Purchase__c newPurchase;
	static void init(){
		//machine=new Machine__c();
		//sparePart=new Machine__c();
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
			
		sparePartUsed=new Spare_Parts_used__c();
		sparePartUsed.Case__c=caseInstance.id;
		sparePartUsed.Spare_Part__c=sparePart.id;
		sparePartUsed.Quantity__c=0;		
		database.insert(sparePartUsed);
		//System.assertEquals([select id from machine__c where id=:sparePart.id],null);
	}
    static testMethod void myUnitTest() { 
        // TO DO: implement unit test
        
        Test.startTest();
        init();
        System.assertEquals(controller.addSparePart(),null);
        controller.newSparePart.Spare_Part__c=sparePart.id;
        System.assertEquals(controller.save(),null);
        
        System.assertNotEquals(controller.getTableValues() , null);
        System.assertNotEquals(controller.getPageURL(),null);
        Test.stopTest();
        
    }
    
}