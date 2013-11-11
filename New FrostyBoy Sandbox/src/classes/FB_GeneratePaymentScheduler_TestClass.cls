@isTest
private class FB_GeneratePaymentScheduler_TestClass {

    static testMethod void myUnitTest() {
        Test.startTest();
        FB_GenerateMonthlyPaymentScheduler generatePayments=new FB_GenerateMonthlyPaymentScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Testing', sch, generatePayments);
        Test.stopTest();
        
    }
}