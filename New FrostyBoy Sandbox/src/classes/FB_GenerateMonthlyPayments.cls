/*
Developer Name: Anjith kumar
Created Date: 28/07/2013
Modified Date: 28/07/2013

Tweaked by 
Developer Name : Rachit Bhargava
Date: 20/09/2013

Purpose: This batch class will call by schedular by initantiating the constructor by passing list of machine locations id  and status as parameters.
        It will generate monthly payments since start date if there is no monthly payment of particular month
        The monthly payment date is last date of the month
*/

/*batch class which implements Database.Batchable interface*/
global class FB_GenerateMonthlyPayments  implements Database.Batchable<sObject>{
   
   public String query;
   public Integer totalMonths;
    public List<Monthly_Payment__c> tempList;
    /* Batch Constructor which initialize the query */ 
    global FB_GenerateMonthlyPayments(){}
    global FB_GenerateMonthlyPayments(List<String> listOflocation,String status){
          System.debug('in');
          status='\''+status+'\'';
          query='select Id,Name,Sale_price__c,Billing_Date__c,End_Date__c,(select id,month__c,Machine_Location__c from Monthly_Payments__r order by month__c desc) from Machine_Inventory__c where status__c='+status+' AND Contract_Start_Date__c<='+String.valueOf(date.today())+' AND Contract_End_Date__c>='+String.valueOf(date.today())+' AND Id IN (';
          for(String location:listOflocation){
              query= query+ '\''+location+'\',';
            }
          query = query.substring(0, query.length()-1)+')';
          System.debug(query);
    }
    
    /* This method will return the list of machineLocation by quering from the database */
    global Database.QueryLocator start(Database.BatchableContext BC){
         return Database.getQueryLocator(query);
    }
    
    /*
      This method execute the main logic to generate monthly payments

    */
    global void execute(Database.BatchableContext BC, List<Machine_Inventory__c> listOfMachineLocations){
      //System.debug(listOfMachineLocations);
      List<Monthly_Payment__c> newListOfPayments=new List<Monthly_Payment__c>();
            for(Machine_Inventory__c machineLocation:listOfMachineLocations){
                   tempList=machineLocation.Monthly_Payments__r;
                   totalMonths=0;
                   Integer month,year;
                   if(tempList.size()==0){
                    //Need to generate monthly payments since bill start date
                    totalMonths=machineLocation.Billing_Date__c.monthsBetween(Date.today());
                    System.debug(totalMonths);
                    month=machineLocation.Billing_Date__c.month();
                    year=machineLocation.Billing_Date__c.year();
                   }
                   else
                    {
                      //find months between lastgeneratedPayment and today and generate monthly payment for those months
                      Date lastGeneratedPayment=tempList[0].month__c;
                      month=lastgeneratedPayment.month();
                      System.debug(month);
                      year=lastgeneratedPayment.year();
                      totalMonths=lastGeneratedPayment.monthsBetween(Date.today());
                      
                   }
                   if(totalMonths!=0)
                   {
                   for(Integer count=0;count<totalMonths+1;count++){

                          Date paymentDate=Date.newInstance(year,month,Date.daysInMonth(year, month));
                          Monthly_Payment__c newPayment=new Monthly_Payment__c();
                          newPayment.name=machineLocation.Name+' '+paymentDate.format();
                          newPayment.Month__c=paymentDate;
                          newPayment.Machine_Location__c=machineLocation.id;
                          if(month==machineLocation.Billing_Date__c.month()&&year==machineLocation.Billing_Date__c.year()){
                              //if the month and year equal to bill start date of machine location then calculate the expected rent for days between bill start date and end date of the month
                              newPayment.Expected_Rent__c =machineLocation.billing_date__c.daysBetween(paymentDate)*(machineLocation.Sale_price__c/(Date.daysInMonth(year, month)));
                              newPayment.Actual_Rent__c =machineLocation.billing_date__c.daysBetween(paymentDate)*(machineLocation.Sale_price__c/(Date.daysInMonth(year, month)));
                          }else if(machineLocation.End_Date__c.month()==month && machineLocation.End_Date__c.year()==year){
                            //if month and year equal to end date of the machine location then calculate the expected rent for days between first day of the month and end date of machine location
                              newPayment.Expected_Rent__c =(machineLocation.Sale_price__c/(Date.daysInMonth(year, month)))*(Date.newInstance(machineLocation.End_Date__c.year(),machineLocation.End_Date__c.month(),1).daysBetween(machineLocation.End_Date__c));
                              newPayment.Actual_Rent__c =(machineLocation.Sale_price__c/(Date.daysInMonth(year, month)))*(Date.newInstance(machineLocation.End_Date__c.year(),machineLocation.End_Date__c.month(),1).daysBetween(machineLocation.End_Date__c));
                          }else{
                            //assigning expected rent as monthly installment amount of machine location
                              newPayment.Expected_Rent__c =machineLocation.Sale_price__c;
                              newPayment.Actual_Rent__c =machineLocation.Sale_price__c;
                          }
                          
                          newListOfPayments.add(newPayment);
                          
                          if(month==12){
                            month=1;
                            year=year+1;
                          }else{
                            month=month+1;
                          }
                     }
                   }
                   else
                   {
                    String abc = machineLocation.Name+' '+Date.newInstance(year,month,Date.daysInMonth(year, month)).format();
                    try
                    {
                        Monthly_Payment__c mp = [select Id from Monthly_Payment__c where Name =:abc AND Machine_Location__c=:machineLocation.Id];
                    }
                    catch(Exception e)
                    {
                        Date paymentDate=Date.newInstance(year,month,Date.daysInMonth(year, month));
                          Monthly_Payment__c newPayment=new Monthly_Payment__c();
                          newPayment.name=machineLocation.Name+' '+paymentDate.format();
                          newPayment.Month__c=paymentDate;
                          newPayment.Machine_Location__c=machineLocation.id;
                          if(month==machineLocation.Billing_Date__c.month()&&year==machineLocation.Billing_Date__c.year()){
                              //if the month and year equal to bill start date of machine location then calculate the expected rent for days between bill start date and end date of the month
                              newPayment.Expected_Rent__c =machineLocation.billing_date__c.daysBetween(paymentDate)*(machineLocation.Sale_price__c/(Date.daysInMonth(year, month)));
                               newPayment.Actual_Rent__c =machineLocation.billing_date__c.daysBetween(paymentDate)*(machineLocation.Sale_price__c/(Date.daysInMonth(year, month)));
                          }else if(machineLocation.End_Date__c.month()==month && machineLocation.End_Date__c.year()==year){
                            //if month and year equal to end date of the machine location then calculate the expected rent for days between first day of the month and end date of machine location
                              newPayment.Expected_Rent__c =(machineLocation.Sale_price__c/(Date.daysInMonth(year, month)))*(Date.newInstance(machineLocation.End_Date__c.year(),machineLocation.End_Date__c.month(),1).daysBetween(machineLocation.End_Date__c));
                              newPayment.Actual_Rent__c =(machineLocation.Sale_price__c/(Date.daysInMonth(year, month)))*(Date.newInstance(machineLocation.End_Date__c.year(),machineLocation.End_Date__c.month(),1).daysBetween(machineLocation.End_Date__c));
                          }else{
                            //assigning expected rent as monthly installment amount of machine location
                              newPayment.Expected_Rent__c =machineLocation.Sale_price__c;
                              newPayment.Actual_Rent__c =machineLocation.Sale_price__c;
                          }
                          
                          newListOfPayments.add(newPayment);
                    }
                     
                   }
          
                    

           }
     if(newListOfPayments.size()!=0){      
        Database.insert(newListOfPayments);
     }
      
  }
    
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }
}