global class FB_SetAcutalRentAsMonthlyRent {
	WebService static String setActualRent(List<String> recordIds){
		//list<String> stringManipulator = new list<String>();
		string soqlQuery='Select Id,Expected_Rent__c,Actual_Rent__c from Monthly_Payment__c where Id IN (';
    	for(String a:recordIds)
    	{
    		soqlQuery=soqlQuery+'\''+a+'\',';
    	}
    	//system.debug(stringManipulator);
    	soqlQuery = soqlQuery.substring(0, soqlQuery.length()-1)+')';
		List<Monthly_Payment__c> paymentList=new List<Monthly_Payment__c>();
		
		List<Monthly_Payment__c> oldPaymentList=Database.query(soqlQuery);
			for(Monthly_Payment__c payment:oldPaymentList){
			Monthly_Payment__c newPayment=payment;
			newPayment.Actual_Rent__c=payment.Expected_Rent__c;
			system.debug(payment);
			paymentList.add(newPayment);
		}
		Database.update(paymentList);
		System.debug(paymentList);
		return 'success';
	}
}