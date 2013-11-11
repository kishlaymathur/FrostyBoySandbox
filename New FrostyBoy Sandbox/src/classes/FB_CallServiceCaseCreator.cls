global class FB_CallServiceCaseCreator {
    WebService static String ExecuteServiceRequestCreator(){
        FB_ServiceCaseCreator batchApex=new FB_ServiceCaseCreator ();
        Id batchProcessId=Database.executeBatch(batchApex);
        return 'success';
    }
}