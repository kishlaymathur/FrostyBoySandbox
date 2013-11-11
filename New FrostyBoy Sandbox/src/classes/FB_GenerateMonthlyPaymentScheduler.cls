global class FB_GenerateMonthlyPaymentScheduler implements Schedulable
{
    
    global void execute(SchedulableContext sc) 
    {
     //  Instantiate batch class 
     FB_GenerateMonthlyPayments batchInstance = new FB_GenerateMonthlyPayments();
     database.executebatch(batchInstance,200);
    }
}