global class FB_ClassGenerateMonthlyPayments {
	WebService static String ExecuteGenerateMonthlyPayment(List<String> listoflocations,String status ){
		System.debug(listoflocations+' ID ');
		FB_GenerateMonthlyPayments batchApex=new FB_GenerateMonthlyPayments(listoflocations,status);
		Id batchProcessId=Database.executeBatch(batchApex);
		return 'success';
	}

}