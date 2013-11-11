@isTest(seealldata=false)
private class FB_GenerateMonthlyPayments_TestClass {
    private static List<Machine__c> machineList;
    private static List<Machine_Inventory__c> machineLocationList;
    private static List<Monthly_Payment__c> monthlyPaymentList;
    private static Monthly_Payment__c payment;
    private static Account customer;
    private static List<String> machineLocationIds;
    static void init(){
    	machineLocationIds=new List<String>();
    	machineList=new List<Machine__c>();
    	payment=new Monthly_Payment__c();
    	machineLocationList=new List<Machine_Inventory__c>();
    	monthlyPaymentList=new List<Monthly_Payment__c>();
    	
    	for(Integer i=0;i<50;i++){
    		machineList.add(FB_InitializeTestData.createMachine(String.valueOf(i)));
    	}
    	Database.Insert(machineList);
    	customer=FB_InitializeTestData.createAccount('TestName');
    	customer.Type='Machine Customer';
    	Database.Insert(customer);
    	for(Machine__c newInstance:machineList){
    		Machine_Inventory__c newMachineLocation=FB_InitializeTestData.createMachineInventory(newInstance.id,customer.id);
    		newMachineLocation.Billing_Date__c=date.today()-365;
    		newMachineLocation.End_Date__c=Date.today()+365;
    		machineLocationList.add(newMachineLocation);
    	}
    	Database.Insert(machineLocationList);
    	for(machine_Inventory__c newLocation:machineLocationList){
    		monthlyPaymentList.add(FB_InitializeTestData.createMonthlyPayments(newLocation.id,'TestPayment'+newLocation.Id));
    		machineLocationIds.add(newLocation.id);
    	}
    	
    	//
    	
    	
    }
    static testMethod void generatePaymentsIfNotThereFromBillStartDate(){
    	
          //System.debug(query);
    	Test.startTest();
    	init();
    	String query='select Id,Name,Sale_price__c,Billing_Date__c,End_Date__c,(select id,month__c,Machine_Location__c from Monthly_Payments__r order by month__c desc) from Machine_Inventory__c where status__c=\'Allocated\' AND Billing_Date__c<='+String.valueOf(date.today())+' AND Id IN (';
          for(String location:machineLocationIds){
              query= query+ '\''+location+'\',';
            }
          query = query.substring(0, query.length()-1)+')';
    	FB_GenerateMonthlyPayments generatePayment=new FB_GenerateMonthlyPayments(machineLocationIds,'Allocated');
    	generatePayment.query=query;
    	ID batchid = Database.executeBatch(generatePayment);
        Test.stopTest();
    }
    
    static testMethod void generatePaymentsIfNotThereFromLastBilledDate(){
        Test.startTest();
        init();
    database.insert(monthlyPaymentList);
        String query='select Id,Name,Sale_price__c,Billing_Date__c,End_Date__c,(select id,month__c,Machine_Location__c from Monthly_Payments__r order by month__c desc) from Machine_Inventory__c where status__c=\'Allocated\' AND Billing_Date__c<='+String.valueOf(date.today())+' AND Id IN (';
          for(String location:machineLocationIds){
              query= query+ '\''+location+'\',';
            }
          query = query.substring(0, query.length()-1)+')';
    	FB_GenerateMonthlyPayments generatePayment=new FB_GenerateMonthlyPayments(machineLocationIds,'Allocated');
    	generatePayment.query=query;
        ID batchid2 = Database.executeBatch(generatePayment);
        Test.stopTest();
    }
}