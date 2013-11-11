@isTest
private class TestTotalCheckController {
    
    static void performSearch(Apexpages.standardController controller) {
        Boolean bool, bool2, bool3, bool4, bool5, bool6;
        TotalCheckController ttlchk = new TotalCheckController(controller);
        ttlchk.pageAction();
        bool = ttlchk.getShowUsageCount();
        ttlchk.getSearchTypes();
        
        // Start testing name search
        ttlchk.primaryName = 'john';
        //List<SelectOption> selOptions = ttlchk.getSearchTypes();
        PageReference PR = ttlchk.searchNames();
        ApexPages.currentPage().getParameters().put('addrNo','1');
        // Start testing address search
        PR = ttlchk.searchAddresses();
        ttlchk.inputHiddenValue = '34 ZigZag Street, SuburbS, MLB'; // selected address
        
        //List<String> addresses = ttlchk.getResultAddresses();
        //bool = ttlchk.hasNoAddress;
        
        // Start testing address select
        PR = ttlchk.selectAddress();
        ttlchk.inputHiddenValue = 'subpremise1/34 ZigZag Street, SuburbS, MLB'; // selected detail
        
        // Start testing address detail select
        PR = ttlchk.selectAddressDetail();
        
        ttlchk.copyAddress();
        // Start testing user action Next
        PR = ttlchk.createRecordPage();
        
        ttlchk.resetFields();
    }
    
    static void performSearchOnLead(Apexpages.standardController controller) {
        Boolean bool, bool2, bool3, bool4, bool5, bool6;
        TotalCheckController ttlchk = new TotalCheckController(controller);
        ttlchk.pageAction();
        bool = ttlchk.getShowUsageCount();
        ttlchk.getSearchTypes();
        
        // Start testing name search
        ttlchk.company = 'PRM';
        //List<SelectOption> selOptions = ttlchk.getSearchTypes();
        PageReference PR = ttlchk.searchCompany();
        ApexPages.currentPage().getParameters().put('addrNo','1');
        // Start testing address search
        PR = ttlchk.searchAddresses();
        ttlchk.inputHiddenValue = '410A High St,WINDSOR VIC 3181'; // selected address
        
        //List<String> addresses = ttlchk.getResultAddresses();
        //bool = ttlchk.hasNoAddress;
        
        // Start testing address select
        PR = ttlchk.selectAddress();
        
        ttlchk.copyAddress();
        
        ApexPages.currentPage().getParameters().put('addrNo','2');
        // Start testing address search
        PR = ttlchk.searchAddresses();
        ttlchk.inputHiddenValue = '410A High St,WINDSOR VIC 3181'; // selected address
        
        //List<String> addresses = ttlchk.getResultAddresses();
        //bool = ttlchk.hasNoAddress;
        
        // Start testing address select
        PR = ttlchk.selectAddress();
        
        ttlchk.phoneNumber = '(03) 9529-8733';
        ApexPages.currentPage().getParameters().put('phone','1');
        PR = ttlchk.searchAddresses();
        ttlchk.inputHiddenValue = '410A High St,WINDSOR VIC 3181';
        PR = ttlchk.selectAddress();
        
        // Start testing user action Next
        PR = ttlchk.createRecordPage();
        PR = ttlchk.goBack();
        
    }
    

    static testMethod void testController(){
        TotalCheckConnector__c dataSet;
        TotalCheckAPIController ctrller = new TotalCheckAPIController();
        dataSet = ctrller.getTCCustomSetting();
        system.debug(dataSet);
        // Test with trial user; directly access custom setting
        dataSet.TCUsername__c = 'trialuser';
        dataSet.TCPassword__c = 'trialpass';
        dataSet.Trial_User__c = true;
        dataSet.TCUsageCount__c = 0;
        
        if(dataSet.Id != NULL)
            update dataSet;
        else
            insert dataSet;
        
        system.debug(dataset);
        system.debug(ctrller.getTCCustomSetting());
        ApexPages.StandardController sc;
        Account acc = new Account(name='testAccount');
        insert acc;
        
        // Account
        PageReference pageRef = new PageReference('/apex/TotalCheckAccount?id='+acc.id);
        Test.setCurrentPage(pageRef); // Test the TotalCheck page
        sc = new ApexPages.StandardController(acc);
        performSearch(sc);
        
         // Assert by directly fetching the custom setting
        System.assertEquals(TotalCheckConnector__c.getValues('TotalCheckStore').TCUsageCount__c, 1);
        
        Contact con = new Contact(lastname = 'testContact');
        insert con;
        // Contact
        pageRef = new PageReference('/apex/TotalCheckContact?id='+con.id);
        Test.setCurrentPage(pageRef); // Test the TotalCheck page
        sc = new ApexPages.StandardController(con);
        performSearch(sc);
        
        Lead l = new Lead(lastname='testLead',company='PRM');
        insert l;
        // Lead
        pageRef = new PageReference('/apex/TotalCheckLead?id='+l.id);
        Test.setCurrentPage(pageRef); // Test the TotalCheck page
        sc = new ApexPages.StandardController(l);
        performSearch(sc);
        
        /** Invalid Obj
        pageRef = new PageReference('/apex/TotalCheckPage?objId=00Q&RecordType=00X21231200121231&ent=Account&retURL=%2F00Q%2Fo');
        Test.setCurrentPage(pageRef); // Test the TotalCheck page
        performSearch();*/
        
        /** Validation
        pageRef = new PageReference('/apex/TotalCheckPage?objId=00Q&validate=1&pName=John&address=zigzag%20street&suburb=suburbs&state=mlb');
        Test.setCurrentPage(pageRef); // Test the TotalCheck page
        performSearch();*/
        
        dataSet = TotalCheckConnector__c.getValues('TotalCheckStore');
        dataSet.Trial_User__c = true;
        dataSet.TCUsageCount__c = 100;
        update dataSet; // trial user, exceeded usage limit
        performSearch(sc);
        
         // Test with licensed user
        dataSet.TCUsername__c = 'trialuser';
        dataSet.TCPassword__c = 'trialpass';
        dataSet.Trial_User__c = false;
        dataSet.TCUsageCount__c = 0;
        update dataSet; 
        // Lead
        pageRef = new PageReference('/apex/TotalCheckLead?id='+l.id);
        Test.setCurrentPage(pageRef); // Test the TotalCheck page
        sc = new ApexPages.StandardController(l);
        performSearch(sc);
        performSearchOnLead(sc);
    }
    
    /**static testMethod void testLeadRedirectController(){
        Lead l = new Lead();
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        LeadRedirectController LRC = new LeadRedirectController(sc);
        Apexpages.currentPage().getParameters().put('objId','00Q');
        PageReference PR = LRC.gotoTotalCheckPage();
        System.assert(PR.getParameters().get('objId') == '00Q');
    }
    
    static testMethod void testContactRedirectController(){
        Contact c = new Contact();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        ContactRedirectController LRC = new ContactRedirectController(sc);
        Apexpages.currentPage().getParameters().put('objId','003');
        PageReference PR = LRC.gotoTotalCheckPage();
        System.assert(PR.getParameters().get('objId') == '003');
    }
    
    static testMethod void testAccountRedirectController(){
        Account a = new Account();
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        AccountRedirectController LRC = new AccountRedirectController(sc);
        Apexpages.currentPage().getParameters().put('objId','001');
        PageReference PR = LRC.gotoTotalCheckPage();
        System.assert(PR.getParameters().get('objId') == '001');
    }*/
   
    static testMethod void testTotalCheckAPIController() {
        PageReference pageRef = new PageReference('/apex/TotalCheckAPIPage');
        Test.setCurrentPageReference(pageRef);
        TotalCheckConnector__c dataSet;
        TotalCheckAPIController ctrller = new TotalCheckAPIController();
        
        ctrller.cancel();
        ctrller.username = 'hello';
        ctrller.password1 = 'password';
        ctrller.password2 = 'password2';
        ctrller.save();
        
        ctrller.username = 'hello';
        ctrller.password1 = 'password';
        ctrller.password2 = 'password';
        ctrller.save();
        dataSet = ctrller.getTCCustomSetting();
        System.debug(dataSet.TCUsername__c+'--->'+ctrller.username);
        System.assert(dataSet.TCUsername__c == ctrller.username);
        System.assert(dataSet.TCPassword__c == ctrller.password1);
        
        ctrller.promoCode = 'SENSISPROMO100';
        ctrller.save();
        System.assert(ctrller.getPromoCodeFieldEditable() == false);
        
        // re enter promo code
        ctrller.promoCode = 'SENSISPROMO100';
        ctrller.save();
        
        ctrller.username = 'hello';
        ctrller.password1 = '';
        ctrller.save();
        
        ctrller.username = '';
        ctrller.promoCode = '';
        ctrller.save();
        
        ctrller.username = 'hello';
        ctrller.promoCode = '';
        ctrller.save();
        
        // delete custom setting
        delete dataSet;
        ctrller = new TotalCheckAPIController();
        ctrller.username = 'hello2';
        ctrller.password1 = 'password2';
        ctrller.password2 = 'password2';
        ctrller.save();
        ctrller.getUsageCount();
        dataSet = TotalCheckConnector__c.getValues('TotalCheckStore');
        System.assert(dataSet.TCUsername__c == ctrller.username);
        System.assert(dataSet.TCPassword__c == ctrller.password1);
        
        }
}