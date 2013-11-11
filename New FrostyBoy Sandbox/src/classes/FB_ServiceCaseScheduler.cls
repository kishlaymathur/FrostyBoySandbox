global class FB_ServiceCaseScheduler implements Schedulable
{
    
    global void execute(SchedulableContext sc) 
    {
        //  Instantiate batch class 
        FB_ServiceCaseCreator batchInstance = new FB_ServiceCaseCreator ();
        database.executebatch(batchInstance,200);
    }
}