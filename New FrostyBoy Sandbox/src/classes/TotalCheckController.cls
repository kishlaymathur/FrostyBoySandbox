/**
* Controller for TotalCheck Account Page
* Makes web service calls, updates records fetched count, controls usage of page based on this
* Author: jeremy@prmcloud.com
*/

public with sharing class TotalCheckController 
{
    public Account theAccount {get;set;}
    public Lead theLead {get;set;}   
    public Contact theContact {get;set;}   
    private sObject stdController;
    
    
    public TotalCheckController(Apexpages.standardController controller){
        
        // Get query string parameters
        String v = Apexpages.currentPage().getParameters().get('validate');
        String v1 = Apexpages.currentPage().getParameters().get('validate1');
        String tName = Apexpages.currentPage().getParameters().get('pName');
        String tCompany = Apexpages.currentPage().getParameters().get('compName');
        String tAddress = Apexpages.currentPage().getParameters().get('address');
        String tSuburb = Apexpages.currentPage().getParameters().get('suburb');
        String tState = Apexpages.currentPage().getParameters().get('state');
        String tPostcode = Apexpages.currentPage().getParameters().get('postcode');
        String tPhoneNumber = Apexpages.currentPage().getParameters().get('phoneNumber');
        phoneNos = new List<SelectOption>();
        lastTimeStamp = 0;
        isEdit = false;
        
        
        primaryName = '';
        address = '';
        suburb = '';
        state = '';
        postcode = '';
        country = '';
        address1 = '';
        suburb1 = '';
        state1 = '';
        postcode1 = '';
        country1 = '';
        company = '';
        phoneNumber = ''; // Not validating search; always empty
        mobilePhoneNumber = '';
        company = '';
        otherPhoneNumber = '';
        inputHiddenValue = '';
        addressResultsJSONMap = '';
        searchType = TotalCheckConstants.SEARCH_TYPE_ALL; // Default search type
        showPage = true;
        hasError = false;
        hasDetailList = false;
        errorMessage = '';
        tablePhoneNumber = '';
        focusElement = '';
        
        resultNames = new List<String>(); // list of name search matches to display to user
        suggestedAddressesMap = new Map<String, TotalCheckWebService.AddressSuggestion>(); // map: addresses displayed to user -> corresponding AddressSuggestion instance
        addressDetailMap = new Map<String, TotalCheckWebService.AddressDetail>(); // map: detail addresses displayed to user -> corresponding AddressDetail instances
        detailAddresses = new List<String>(); // list of detail addresses, if any, to display to user
        addressItemInstance = new AddressItem(); // inner class instance
        
        //Set search types
        stdController = controller.getRecord();
        if(stdController.getSObjectType() == Account.sObjectType)
        {
            objId = Schema.SObjectType.Account.getKeyPrefix();
            theAccount = (Account)stdController;
            if(theAccount.id != null)
            {
                Account acc = [select name,ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity, BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,phone from Account where id=:theAccount.id];
                primaryName = (acc.name != NULL)?acc.name:'';
                address = (acc.BillingStreet != NULL)?acc.BillingStreet:'';
                suburb = (acc.BillingCity != NULL)?acc.BillingCity:'';
                state = (acc.BillingState != NULL)?acc.BillingState:'';
                postcode = (acc.BillingPostalCode != NULL)?acc.BillingPostalCode:'';
                country = (acc.BillingCountry != NULL)?acc.BillingCountry : '';
                address1 = (acc.ShippingStreet != NULL)?acc.ShippingStreet:'';
                suburb1 = (acc.ShippingCity != NULL)?acc.ShippingCity:'';
                state1 = (acc.ShippingState != NULL)?acc.ShippingState:'';
                postcode1 = (acc.ShippingPostalCode != NULL)?acc.ShippingPostalCode:'';
                country1 = (acc.ShippingCountry != NULL)?acc.ShippingCountry : '';
                phoneNumber = (acc.phone != NULL)?acc.phone:'';
                isEdit = true;
            }
        }
        else if(stdController.getSObjectType() == Contact.sObjectType)
        {
            objId = Schema.SObjectType.Contact.getKeyPrefix();
            theContact = (Contact)stdController;
            if(theContact.id != null)
            {
                Contact con = [select name,lastname,firstname,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,phone,MobilePhone,OtherPhone,OtherCountry,OtherState,OtherCity,OtherPostalCode,OtherStreet from Contact where id=:theContact.id];
                primaryName = (con.lastname != NULL)?con.lastname:'';
                secondaryName = (con.firstname != NULL)?con.firstname:'';
                address = (con.MailingStreet != NULL)?con.MailingStreet:'';
                suburb = (con.MailingCity != NULL)?con.MailingCity:'';
                state = (con.MailingState != NULL)?con.MailingState:'';
                postcode = (con.MailingPostalCode != NULL)?con.MailingPostalCode:'';
                country = (con.MailingCountry != NULL)?con.MailingCountry : '';
                address1 = (con.OtherStreet != NULL)?con.OtherStreet:'';
                suburb1 = (con.OtherCity != NULL)?con.OtherCity:'';
                state1 = (con.OtherState != NULL)?con.OtherState:'';
                postcode1 = (con.OtherPostalCode != NULL)?con.OtherPostalCode:'';
                country1 = (con.OtherCountry != NULL)?con.OtherCountry : '';
                phoneNumber = (con.phone != NULL)?con.phone:'';
                mobilePhoneNumber = (con.MobilePhone != NULL)?con.MobilePhone:'';
                otherPhoneNumber = (con.OtherPhone != NULL)?con.OtherPhone:'';
                isEdit = true;
            }
        }
        else if(stdController.getSObjectType() == Lead.sObjectType)
        {
            objId = Schema.SObjectType.Lead.getKeyPrefix();
            theLead = (Lead)stdController;
            
            if(theLead.id != null)
            {
                Lead l = [select name,lastname,firstname,street,City,state,PostalCode,Country,phone,MobilePhone,Company, ttlchk_searchType__c from Lead where id=:theLead.id];
                primaryName = (l.lastname != NULL)?l.lastname:'';
                secondaryName = (l.firstname != NULL)?l.firstname:'';
                address = (l.street != NULL)?l.street:'';
                suburb = (l.City != NULL)?l.City:'';
                state = (l.state != NULL)?l.state:'';
                postcode = (l.PostalCode != NULL)?l.PostalCode:'';
                country = (l.Country != NULL)?l.Country:'';
                phoneNumber = (l.phone != NULL)?l.phone:'';
                mobilePhoneNumber = (l.MobilePhone != NULL)?l.MobilePhone:'';
                company = (l.company != NULL)?l.company:'';
                searchType = (l.ttlchk_searchType__c != NULL)?l.ttlchk_searchType__c:'';
                isEdit = true;
            }
        }
        else
            objId = '000';//force invalid
            
            
        system.debug(objId);
        system.debug(objId.substring(0, 3));
        if(TotalCheckConstants.LEAD_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3))) //Contacts or Leads
        {
            if(searchType == null)
                this.searchType = 'Residential';
        }
        else if(TotalCheckConstants.ACCOUNT_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)) || TotalCheckConstants.CONTACT_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3))) //Accounts
            this.searchType = 'Both'; //Can be Personal or Business  
        else { // Invalid
            showPage = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select New Account, Contact or Lead option to use this page'));
        }
        
        addressResultsJSONMap = '';
        
        // bool to check if page is validating a record or creating new one
        isValidate = (v != NULL && v == '1');
        isValidate1 = (v1 != NULL && v1 == '1');
        /**if(isValidate) 
        {
            primaryName = (tName != NULL)?tName:'';
            company = (tCompany != NULL)?tCompany:'';
            address = (tAddress != NULL)?tAddress:'';
            suburb = (tSuburb != NULL)?tSuburb:'';
            state = (tState != NULL)?tState:'';
            postcode = (tPostcode != NULL)?tPostcode:'';
        }*/
    
    }
    
    // Begin public variable-properties
    public String primaryName {get; set;}
    public String secondaryName {get; set;}
    public String address {get; set;}
    public String suburb {get; set;}
    public String state {get; set;}
    public String postcode {get; set;}
    public String country {get; set;}
    public String address1 {get; set;}
    public String suburb1 {get; set;}
    public String state1 {get; set;}
    public String postcode1 {get; set;}
    public String country1 {get; set;}
    public String phoneNumber {get; set;}
    public String mobilePhoneNumber {get; set;}
    public String otherPhoneNumber {get; set;}
    public String company {get; set;}
    public String searchType {get;set;}
    public String inputHiddenValue {get;set;}
    public String errorMessage {get;set;}
    public Boolean hasError {get;set;}
    public Boolean hasDetailList {get; set;}
    public Boolean isValidate {get; private set;} // Don't allow to be set via the page
    public Boolean isValidate1 {get; private set;} // Don't allow to be set via the page
    public Boolean hasNoNames {get; private set;}
    public Boolean hasNoAddress {get; private set;}
    public Boolean showPage {get; private set;}
    public Integer usageCount {get; private set;}
    public List<String> detailAddresses {get; private set;}
    public TotalCheckWebService.SelectAddressResult selectedAddressResult {get; private set;}
    public AddressItem addressItemInstance {get; private set;}
    public List<String> resultNames {get; private set;}
    public String addressResultsJSONMap {get; private set;}
    public String tablePhoneNumber {get; set;}
    public List<SelectOption> phoneNos {get;set;}
    public String focusElement {get;set;}
    public String addr {get;set;}
    public String phone;
    
    // Begin private variables
    private String objId {get; set;}
    private TotalCheckConnector__c dataSet {get; set;}
    private TotalCheckAPIController tcApi {get; set;}
    private TotalCheckWebService.TotalCheckServiceImplPort ws {get; set;}
    private Map<String, TotalCheckWebService.AddressSuggestion> suggestedAddressesMap {get; set;}
    private Map<String, TotalCheckWebService.AddressDetail> addressDetailMap {get; set;}
    private Long lastTimeStamp {get; set;}
    
    public Boolean isEdit{get;set;}
    
    
    // Begin public properties
    /* Determine if usage count is to be shown on page based on user licence */
    public Boolean getShowUsageCount() 
    {
        return dataSet.Trial_User__c;
    }
    
    
    
    // Begin Constructors
    
    /* Default constructor */
  /**  public TotalCheckAccountController()
    {
        // Get query string parameters
        String v = Apexpages.currentPage().getParameters().get('validate');
        String tName = Apexpages.currentPage().getParameters().get('pName');
        String tAddress = Apexpages.currentPage().getParameters().get('address');
        String tSuburb = Apexpages.currentPage().getParameters().get('suburb');
        String tState = Apexpages.currentPage().getParameters().get('state');
        String tPostcode = Apexpages.currentPage().getParameters().get('postcode');
        String tPhoneNumber = Apexpages.currentPage().getParameters().get('phoneNumber');
        phoneNos = new List<SelectOption>();
        lastTimeStamp = 0;
        
        // bool to check if page is validating a record or creating new one
        isValidate = (v != NULL && v == '1');
        if(isValidate) 
        {
            // bind fields to values passed in
            primaryName = (tName != NULL)?tName:'';
            address = (tAddress != NULL)?tAddress:'';
            suburb = (tSuburb != NULL)?tSuburb:'';
            state = (tState != NULL)?tState:'';
            postcode = (tPostcode != NULL)?tPostcode:'';
            //phoneNumber = (tPhoneNumber != NULL)?tPhoneNumber:'';
        }
        else 
        {
            // set to empty if new
            primaryName = '';
            address = '';
            suburb = '';
            state = '';
            postcode = '';
            //phoneNumber = '';
        }
        phoneNumber = ''; // Not validating search; always empty
        inputHiddenValue = '';
        addressResultsJSONMap = '';
        searchType = TotalCheckConstants.SEARCH_TYPE_ALL; // Default search type
        showPage = true;
        hasError = false;
        hasDetailList = false;
        errorMessage = '';
        tablePhoneNumber = '';
        
        resultNames = new List<String>(); // list of name search matches to display to user
        suggestedAddressesMap = new Map<String, TotalCheckWebService.AddressSuggestion>(); // map: addresses displayed to user -> corresponding AddressSuggestion instance
        addressDetailMap = new Map<String, TotalCheckWebService.AddressDetail>(); // map: detail addresses displayed to user -> corresponding AddressDetail instances
        detailAddresses = new List<String>(); // list of detail addresses, if any, to display to user
        addressItemInstance = new AddressItem(); // inner class instance
        
        //Set search type
        objId = Apexpages.currentPage().getParameters().get('objId');
        if(objId == NULL || objId.length() < 3)
            objId = '000'; // force invalid
            
        system.debug(objId);
        system.debug(objId.substring(0, 3));
        if(TotalCheckConstants.CONTACT_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)) || TotalCheckConstants.LEAD_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3))) //Contacts or Leads
            this.searchType = 'Residential';
        else if(TotalCheckConstants.ACCOUNT_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3))) //Accounts
            this.searchType = 'Both'; //Can be Personal or Business  
        else { // Invalid
            showPage = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select New Account, Contact or Lead option to use this page'));
        }
        
        addressResultsJSONMap = '';
    }*/
    
    // Begin public methods
    /* Loads custom settings, initializes Web service callout instance etc. Might include DML operations, called out of constructor*/
    public PageReference pageAction() {
        // Get credentials etc from custom setting
        fetchCustomSetting(); // might make DML calls
        
        // initialize web service callout 
        ws = new TotalCheckWebService.TotalCheckServiceImplPort(dataSet.TCUsername__c, dataSet.TCPassword__c);
        
        usageCount = Integer.valueOf(dataSet.TCUsageCount__c); // current usage count
        
        if(usageCount >= 100 && dataSet.Trial_User__c){ // Check usage only for trial users 
            showPage = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Exceeded 100 records limit'));
        }
        
        return NULL;
    }
    
    /* Display search type options to user */
    public List<SelectOption> getSearchTypes() {
        // List of address search types available
        List<SelectOption> searchTypes = new List<SelectOption>(); 
        searchTypes.add(new SelectOption(TotalCheckConstants.SEARCH_TYPE_RESIDENTIAL, 'Validate Individual')); 
        searchTypes.add(new SelectOption(TotalCheckConstants.SEARCH_TYPE_BUSINESS, 'Validate Company')); 
        if(!TotalCheckConstants.LEAD_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)))
            searchTypes.add(new SelectOption(TotalCheckConstants.SEARCH_TYPE_ALL, 'All')); 
        system.debug(searchType);
        return searchTypes; 
    }
    
    
    
    /* Look for names based on partial user input for name */
    public PageReference searchNames(){
        // calls suggestNames method of the web service
        //system.debug(ApexPages.currentPage().getParameters());
        //system.debug(ApexPages.currentPage().getParameters().get('focElt'));
        //system.debug(focusElement + '          ' + searchType);
        
        system.debug('suggestNames');
        resultNames.clear();
        hasNoNames = true;
        // update credentials etc from custom setting; might have changed from other page requests 
        fetchCustomSetting();
        usageCount = Integer.valueOf(dataSet.TCUsageCount__c);
        if(!dataSet.Trial_User__c || usageCount < 100){ // Check usage limit only for trial users
            try{
                List<String> suggestNames;
                system.debug(this.searchType);
                //if(TotalCheckConstants.LEAD_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)) && focusElement == 'company')
                //  suggestNames = ws.suggestNames(TotalCheckConstants.SEARCH_TYPE_BUSINESS, company); // make the call
                if(TotalCheckConstants.LEAD_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)))
                    suggestNames = ws.suggestNames(TotalCheckConstants.SEARCH_TYPE_RESIDENTIAL, primaryName); // make the call
                else
                    suggestNames = ws.suggestNames(searchType, primaryName); // make the call
                system.debug(suggestNames);
                if(suggestNames == NULL)
                    suggestNames = new List<String>();
                for(String name : suggestNames){
                    name = String.escapeSingleQuotes(name);
                    // prefix, suffix with "'" as this will be rendered directly as JSON array on page
                    resultNames.add('\'' + name + '\'');
                    hasNoNames = false;
                }
                
                /*if(TotalCheckConstants.LEAD_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)))
                {
                    if(focusElement == 'name' && searchType == 'Business')
                    {
                        resultNames.clear();
                        hasNoNames = true;
                    }
                    else if(focusElement == 'company' && searchType == 'Residential')
                    {
                        resultNames.clear();
                        hasNoNames = true;
                    }
                }*/
            }
            catch(TotalCheckWebService.ClientSystemException e){ // exception with web service
                errorMessage = 'Service is down or Unavailable. The Server returned: ' + e.getMessage();
                hasError = true;
            }
            catch(Exception ex){ // other exception 
                //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'There was some problem constructing the Web Service. Developer info: ' + ex.getMessage()));
                errorMessage = 'Too many results. Please refine the criteria.';
                hasError = true;
                system.debug(ex);
            }
        }
        else{ // trial usage exceeded
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Exceeded 100 records limit'));
            showPage = false;
            hasError = false; // Used to display custom error messages; not <apex:pageMessages/>
        }
        
        return NULL;
    }
    
    public PageReference searchCompany(){
        // calls suggestNames method of the web service
        //system.debug(ApexPages.currentPage().getParameters());
        //system.debug(ApexPages.currentPage().getParameters().get('focElt'));
        //system.debug(focusElement + '          ' + searchType);
        
        system.debug('suggestNames');
        resultNames.clear();
        hasNoNames = true;
        // update credentials etc from custom setting; might have changed from other page requests 
        fetchCustomSetting();
        usageCount = Integer.valueOf(dataSet.TCUsageCount__c);
        if(!dataSet.Trial_User__c || usageCount < 100){ // Check usage limit only for trial users
            try{
                List<String> suggestNames;
                system.debug(this.searchType);
                //if(TotalCheckConstants.LEAD_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)) && focusElement == 'company')
                    suggestNames = ws.suggestNames(TotalCheckConstants.SEARCH_TYPE_BUSINESS, company); // make the call
                // make the call
                system.debug(suggestNames);
                if(suggestNames == NULL)
                    suggestNames = new List<String>();
                for(String name : suggestNames){
                    name = String.escapeSingleQuotes(name);
                    // prefix, suffix with "'" as this will be rendered directly as JSON array on page
                    resultNames.add('\'' + name + '\'');
                    hasNoNames = false;
                }
                
                /*if(TotalCheckConstants.LEAD_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)))
                {
                    if(focusElement == 'name' && searchType == 'Business')
                    {
                        resultNames.clear();
                        hasNoNames = true;
                    }
                    else if(focusElement == 'company' && searchType == 'Residential')
                    {
                        resultNames.clear();
                        hasNoNames = true;
                    }
                }*/
            }
            catch(TotalCheckWebService.ClientSystemException e){ // exception with web service
                errorMessage = 'Service is down or Unavailable. The Server returned: ' + e.getMessage();
                hasError = true;
            }
            catch(Exception ex){ // other exception 
                //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'There was some problem constructing the Web Service. Developer info: ' + ex.getMessage()));
                errorMessage = 'Too many results. Please refine the criteria.';
                hasError = true;
                system.debug(ex);
            }
        }
        else{ // trial usage exceeded
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Exceeded 100 records limit'));
            showPage = false;
            hasError = false; // Used to display custom error messages; not <apex:pageMessages/>
        }
        
        return NULL;
    }
    
    
    /* Look for addresses based on user input for name */
    public PageReference searchAddresses(){
        
        addr = ApexPages.currentPage().getParameters().get('addrNo');
        phone = ApexPages.currentPage().getParameters().get('phone');
        
        inputHiddenValue = '';
        addressResultsJSONMap = '';
        hasError = false;
        hasNoNames = true;
        hasNoAddress = true;
        resultNames.clear();
        suggestedAddressesMap.clear();
        detailAddresses.clear();
        addressDetailMap.clear();
        addressItemInstance = new AddressItem();
        
        
        Long currentTimestamp = system.now().getTime();
        system.debug('starting searchAddresses ' + currentTimestamp);
        String ts = ApexPages.currentPage().getParameters().get('timestamp');
        ts = (ts == NULL || ts == '')?'0':ts; // can't be null or empty
        Long incomingCallTimestamp = Long.valueOf(ts);
        system.debug('incomingCallTimestamp' + incomingCallTimestamp);
        system.debug('lastTimeStamp' + lastTimeStamp);
        /*if(!compareTimestamps(incomingCallTimestamp))
            return NULL;*/ // out of date call, exit; TODO: this needs to be worked upon. currently facing racing condition issues with lastTimeStamp
        
        system.debug('lastTimeStamp' + lastTimeStamp);
        
        // clear out previous results, if any
        suggestedAddressesMap.clear();
        addressResultsJSONMap = '';
        hasNoAddress = true;
        // update credentials etc from custom setting; might have changed from other page requests 
        fetchCustomSetting();
        usageCount = Integer.valueOf(dataSet.TCUsageCount__c);
        if(!dataSet.Trial_User__c || usageCount < 100){ // Check usage limit only for trial users
            try{
                TotalCheckWebService.AddressSearch search = new TotalCheckWebService.AddressSearch();
                // fill up what's available to make the search
                if(TotalCheckConstants.LEAD_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)) && this.searchType == TotalCheckConstants.SEARCH_TYPE_BUSINESS)
                    search.name = company;
                else
                    search.name = primaryName;
                search.searchType = searchType;
                if(addr.equals('2'))
                {
                    search.formattedAddress = address1;
                    search.suburb = suburb1;
                    search.state = state1;
                    search.postcode = postcode1;
                }
                else
                {
                    search.formattedAddress = address;
                    search.suburb = suburb;
                    search.state = state;
                    search.postcode = postcode;
                    //if(!isValidate)
                    //{
                        if(phone == '1' && phoneNumber != null && phoneNumber != '')
                        {
                            search.formattedAddress = '';
                            search.suburb = '';
                            search.state = '';
                            search.postcode = '';
                            search.phoneNumber = phoneNumber;
                        }
                        
                        //if((phoneNumber == null || phoneNumber == '') && (mobilePhoneNumber != null && mobilePhoneNumber != ''))
                            //search.phoneNumber = mobilePhoneNumber;
                    //}
                    /*else if(isValidate == true && (address == null || address == '') && (suburb == null || suburb == '') && (state == null || state == '') &&(postcode == null || postcode == ''))
                    {
                        search.phoneNumber = phoneNumber;
                        //if((phoneNumber == null || phoneNumber == '') && (mobilePhoneNumber != null && mobilePhoneNumber != ''))
                            //search.phoneNumber = mobilePhoneNumber;
                    }*/
                }
                isValidate = false;
                
                search.formattedAddressIncludesPostcode = false; // separate fields provided for these
                search.formattedAddressIncludesState = false;
                search.formattedAddressIncludesSuburb = false;
                TotalCheckWebService.suggestAddressesResult addResult = ws.suggestAddresses(search); // make the call
                
                system.debug(addResult.resultStatus);
                
                if(addResult.resultStatus == 2) { // No results found
                    hasNoAddress = true; //for displaying below message
                    // prefix, suffix with "'" as this will be rendered directly as JSON array on page
                    addressResultsJSONMap = '\'No results\':false';
                    hasNoAddress = true;
                    /*if(!TotalCheckConstants.ACCOUNT_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)))
                    {
                        if(phone == '1' && phoneNumber != null && phoneNumber != '')
                        {
                            Set<String> setOfPhoneNumbers = new Set<String>();
                            setOfPhoneNumbers.add(phoneNumber);                     
                            mobilePhoneNumber = findMobileNumber(setOfPhoneNumbers);
                            if(mobilePhoneNumber != null && mobilePhoneNumber != '')
                                phoneNumber = '';
                            system.debug('phone number :  '+phoneNumber);
                            system.debug('mobile number :  '+mobilePhoneNumber);
                        }
                    }*/
                    return NULL;
                }
                else if(addResult.resultStatus == 3) { // Too many Results
                    hasNoAddress = true; //for displaying below message
                    // prefix, suffix with "'" as this will be rendered directly as JSON array on page
                    addressResultsJSONMap = '\'Too many results\':false';
                    hasNoAddress = true;
                    return NULL;
                }
                else if(addResult.resultStatus == 1) { // valid results
                    String jsonglue = '';
                    for(TotalCheckWebService.addressSuggestion aResult : addResult.resultList){
                        // Replace multiple whitespace chars with single whitespace char; browsers will NOT regard these as non-breaking space
                        String tAddress = aResult.formattedAddress.replaceAll('[\\s]+',' ');
                        tAddress = String.escapeSingleQuotes(tAddress);
                        // prefix, suffix with "'" as this will be rendered directly as JSON array on page
                        addressResultsJSONMap += jsonglue + '\'' + tAddress + '\':' + aResult.whitePages;
                        jsonglue = ',';
                        suggestedAddressesMap.put(tAddress, aResult);
                        hasNoAddress = false;
                     }
                }
            }
            catch(TotalCheckWebService.ClientSystemException e){ // exception with web service
                errorMessage = 'Service is down or Unavailable. The Server returned: ' + e.getMessage();
                hasError = true;
            }
            catch(Exception ex){ // other exception 
                //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'There was some problem constructing the Web Service. Developer info: ' + ex.getMessage()));
                //errorMessage = 'There was some problem constructing the Web Service. Developer info: ' + ex.getMessage();
                errorMessage = 'Too many results. Please refine the criteria.';
                hasError = true;
            }
        }
        else{ // trial usage exceeded
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Exceeded 100 records limit'));
            showPage = false;
            hasError = false; // Used to display custom error messages; not <apex:pageMessages/>
        }
        system.debug(suggestedAddressesMap.keySet().size());
        for(String str : suggestedAddressesMap.keySet()){
            system.debug(str);
        }
        currentTimestamp = system.now().getTime();
        system.debug('ending searchAddresses ' + currentTimestamp);
        return NULL;
    }
    
    /* Work on AddressSuggestion item selected by user */
    public PageReference selectAddress() {
        system.debug('entered');
        hasError = false;
        // clear out previous results, if any
        detailAddresses.clear();
        addressDetailMap.clear();
        // update credentials etc from custom setting; might have changed from other page requests 
        fetchCustomSetting();
        usageCount = Integer.valueOf(dataSet.TCUsageCount__c);
        system.debug(inputHiddenValue);
        system.debug(suggestedAddressesMap.keySet().size());
        for(String str : suggestedAddressesMap.keySet()){
            system.debug(str);
        }
        TotalCheckWebService.AddressSuggestion suggestion = suggestedAddressesMap.get(inputHiddenValue); // selected value sent here;
                                                                                                         // fetch from map corresponding AddressSuggestion instance
        system.debug(suggestion);
        if(suggestion != NULL) {
            if(!dataSet.Trial_User__c || usageCount < 100){ // Check usage limit only for trial users
                try{
                    selectedAddressResult = ws.selectAddress(suggestion); // fetch from map selected AddressSuggestion instance
                    system.debug(selectedAddressResult.resultStatus);
                    if(selectedAddressResult.resultStatus == 4) {
                        // Incorrect index/addressSuggestion passed in calling selectAddress()
                        errorMessage = 'There was something wrong with the API call. If this error continues to occur please contact support@prm.com.au';
                        hasError = true;
                    }
                    else {  // valid results
                        // make sure to empty a string that might be actually null
                        if(selectedAddressResult.buildingName == NULL)
                            selectedAddressResult.buildingName = '';
                        if(selectedAddressResult.subPremise == NULL)
                            selectedAddressResult.subPremise = '';
                        if(selectedAddressResult.streetNumber == NULL)
                            selectedAddressResult.streetNumber = '';
                        if(selectedAddressResult.streetName == NULL)
                            selectedAddressResult.streetName = '';
                        if(selectedAddressResult.streetSuffix == NULL)
                            selectedAddressResult.streetSuffix = '';
                        if(selectedAddressResult.streetType == NULL)
                            selectedAddressResult.streetType = '';
                            
                        String pName = primaryName;
                        String sName = secondaryName;
                        String cName = company;
                        Boolean PAFaddr = false;
                        // Do not empty name if WS returns null
                        if(selectedAddressResult.primaryName != NULL && selectedAddressResult.primaryName.length() > 0) {
                            if(TotalCheckConstants.LEAD_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)) && searchType == TotalCheckConstants.SEARCH_TYPE_BUSINESS)
                                company = selectedAddressResult.primaryName;
                            else
                            {
                                primaryName = selectedAddressResult.primaryName;
                                secondaryName = selectedAddressResult.secondaryName;
                            }
                        }
                        else { // No name was returned from WS. Reuse what user entered
                            errorMessage = 'Not a White Pages® address, therefore name not matched. Retained input name';
                            hasError = true;
                            PAFaddr = true;
                        }
                        system.debug(selectedAddressResult.primaryName);
                        system.debug(selectedAddressResult.secondaryName);
                        
                        address = toProperCase(selectedAddressResult.buildingName) + ' ' + toProperCase(selectedAddressResult.subPremise) + ' ' + toProperCase(selectedAddressResult.streetNumber) + ' ' + toProperCase(selectedAddressResult.streetName) + ' ' + toProperCase(selectedAddressResult.streetType) + ' ' + toProperCase(selectedAddressResult.streetSuffix);
                        address = address.trim();
                        suburb = selectedAddressResult.suburb;
                        postcode = selectedAddressResult.postcode;
                        state = selectedAddressResult.state;
                        if(selectedAddressResult.phoneNumber != null)
                        {
                            phoneNumber = selectedAddressResult.phoneNumber;
                            if(phoneNumber != null)
                            {
                                phoneNumber = phoneNumber.replaceAll('-',' ');
                                phoneNumber = phoneNumber.replaceAll('[()]','');
                            }
                        }
                        system.debug(phoneNumber);
                        
                        // capture selected address details 
                        addressItemInstance = new AddressItem(); //clear out old values
                        if(TotalCheckConstants.LEAD_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)) && searchType == TotalCheckConstants.SEARCH_TYPE_BUSINESS)
                        {
                            if(PAFaddr == false)
                                addressItemInstance.primaryName = company;
                            else
                                addressItemInstance.primaryName = cName;
                        }
                        else 
                        {
                            if(PAFaddr == false)
                            {
                                addressItemInstance.primaryName = primaryName;
                                addressItemInstance.secondaryName = secondaryName;
                            }
                            else
                            {
                                addressItemInstance.primaryName = pName;
                                addressItemInstance.secondaryName = sName;
                            }
                        }
                        
                        addressItemInstance.buildingName = selectedAddressResult.buildingName;
                        addressItemInstance.subPremise = selectedAddressResult.subPremise;
                        addressItemInstance.street = address;
                        addressItemInstance.suburb = suburb;
                        addressItemInstance.state = state;
                        addressItemInstance.postcode = postcode;
                        if(PAFaddr == false)
                            addressItemInstance.firstPhoneNumber = phoneNumber;
                        system.debug(addressItemInstance.firstPhoneNumber);
                        addressItemInstance.streetNumber = selectedAddressResult.streetNumber;
                        addressItemInstance.streetName = selectedAddressResult.streetName;
                        addressItemInstance.streetType = selectedAddressResult.streetType;
                        addressItemInstance.bsp = selectedAddressResult.bsp;
                        addressItemInstance.dpid = selectedAddressResult.dpid;
                        //addressItemInstance.wplistingtype = selectedAddressResult.wplistingtype;
                        addressItemInstance.barcode = selectedAddressResult.barcode;
                        addressItemInstance.formattedAddress = address + ' <br/>' + suburb + ' ' + state + ' ' + postcode;
                            
                        if(phoneNumber != NULL)
                            addressItemInstance.phoneNumbers.add(phoneNumber);
                        if(selectedAddressResult.alternativePhoneNumbers != NULL)
                            addressItemInstance.phoneNumbers.addAll(selectedAddressResult.alternativePhoneNumbers);
                        system.debug(selectedAddressResult.alternativePhoneNumbers);
                        addressItemInstance.wpListingType = (selectedAddressResult.wpListingType != NULL)?selectedAddressResult.wpListingType:'';
                        addressItemInstance.listSize = addressItemInstance.phoneNumbers.size();
                        
                        System.debug(selectedAddressResult.alternativePhoneNumbers);
                        
                        if(selectedAddressResult.detailList != NULL) {
                            // selected address as a list of sub premise addresses - unit 1, 2 etc or ground floor, 1st floor etc
                            hasDetailList = true;
                            for(TotalCheckWebService.addressDetail detailAddress : selectedAddressResult.detailList) {
                                String fAddress = String.escapeSingleQuotes(detailAddress.formattedAddress);
                                // prefix, suffix with "'" as this will be rendered directly as JSON array on page
                                detailAddresses.add('\'' + fAddress + '\'');
                                addressDetailMap.put(fAddress, detailAddress);
                            }
                        }
                        else {
                            // While validating, there is a special case to be considered. If an address was originally selected from a detail list,
                            // that option is also displayed directly along with the usual results from addressSugget()
                            // Selecting this gives incorrect details viz. NULL for primaryName, phoneNumber and wpListingType (atleast)
                            
                            hasDetailList = false; // selected address is final, doesn't have an sub premise
                        }
                        
                        if(PAFaddr == false)
                        {
                        if(objId == Schema.Sobjecttype.Account.getKeyPrefix())
                        {
                            primaryName = (addressItemInstance.primaryName == NULL)?'':addressItemInstance.primaryName;
                            //secondaryName = (addressItemInstance.secondaryName == NULL)?'':addressItemInstance.secondaryName;
                            address = (addressItemInstance.street == NULL)?'':addressItemInstance.street;
                            suburb = (addressItemInstance.suburb == NULL)?'':addressItemInstance.suburb;
                            state = (addressItemInstance.state == NULL)?'':addressItemInstance.state;
                            postcode = (addressItemInstance.postcode == NULL)?'':addressItemInstance.postcode;
                            phoneNumber = '';
            
                            List<String> phoneNumberList = new List<String>(); // Needs to be List<> for indexing
                            phoneNumberList.addAll(addressItemInstance.phoneNumbers);
                            phoneNumber = phoneNumberList.isEmpty()?'':phoneNumberList[0];        
                        }
                        
                        else if(objId == Schema.Sobjecttype.Contact.getKeyPrefix())
                        {
                            primaryName = (addressItemInstance.primaryName == NULL)?'':addressItemInstance.primaryName;
                            secondaryName = (addressItemInstance.secondaryName == NULL)?'':addressItemInstance.secondaryName;
                            address = (addressItemInstance.street == NULL)?'':addressItemInstance.street;
                            suburb = (addressItemInstance.suburb == NULL)?'':addressItemInstance.suburb;
                            state = (addressItemInstance.state == NULL)?'':addressItemInstance.state;
                            postcode = (addressItemInstance.postcode == NULL)?'':addressItemInstance.postcode;
                            mobilePhoneNumber = findMobileNumber(addressItemInstance.phoneNumbers);
                            phoneNumber = '';
                            otherPhoneNumber = '';
                            if(mobilePhoneNumber != NULL)
                                addressItemInstance.phoneNumbers.remove(mobilePhoneNumber);
                            else
                                mobilePhoneNumber = '';
                            if(!addressItemInstance.phoneNumbers.isEmpty()) 
                            {
                                List<String> phoneNumberList = new List<String>(); // Needs to be List<> for indexing
                                phoneNumberList.addAll(addressItemInstance.phoneNumbers);
                                phoneNumber = phoneNumberList[0];
                                addressItemInstance.phoneNumbers.remove(phoneNumber);
                            }
        
                            if(!addressItemInstance.phoneNumbers.isEmpty()) {
                                List<String> phoneNumberList = new List<String>(); // Needs to be List<> for indexing
                                phoneNumberList.addAll(addressItemInstance.phoneNumbers);
                                otherPhoneNumber = phoneNumberList[0];
                                addressItemInstance.phoneNumbers.remove(otherPhoneNumber);
                            }
                            if(phoneNumber == mobilePhoneNumber)
                                phoneNumber = '';
        
                        }
                        
                        else if(objId == Schema.Sobjecttype.Lead.getKeyPrefix())
                        {
                            if(searchType == TotalCheckConstants.SEARCH_TYPE_BUSINESS)
                                company = (addressItemInstance.primaryName == NULL)?'':addressItemInstance.primaryName;
                            else
                            {
                                primaryName = (addressItemInstance.primaryName == NULL)?'':addressItemInstance.primaryName;
                                secondaryName = (addressItemInstance.secondaryName == NULL)?'':addressItemInstance.secondaryName;
                            }
                            address = (addressItemInstance.street == NULL)?'':addressItemInstance.street;
                            suburb = (addressItemInstance.suburb == NULL)?'':addressItemInstance.suburb;
                            state = (addressItemInstance.state == NULL)?'':addressItemInstance.state;
                            postcode = (addressItemInstance.postcode == NULL)?'':addressItemInstance.postcode;
                            mobilePhoneNumber = findMobileNumber(addressItemInstance.phoneNumbers);
                            phoneNumber = '';
            
                            if(mobilePhoneNumber != NULL) {
                                addressItemInstance.phoneNumbers.remove(mobilePhoneNumber);
                            }
                            else {
                                mobilePhoneNumber = '';
                            }
                            List<String> phoneNumberList = new List<String>(); // Needs to be List<> for indexing
                            phoneNumberList.addAll(addressItemInstance.phoneNumbers);
                            
                            if(!addressItemInstance.phoneNumbers.isEmpty()) {
                                phoneNumber = phoneNumberList[0];
                            }
                            if(phoneNumber == mobilePhoneNumber)
                                phoneNumber = '';
                        }
                        }
                        // Update usage count
                        dataSet.TCUsageCount__c++;
                        usageCount = Integer.valueOf(dataSet.TCUsageCount__c);
                        
                        update dataSet;
                        system.debug(dataSet);
                        
                     }
                }
                catch(TotalCheckWebService.ClientSystemException e){ // exception with web service
                    errorMessage = 'Service is down or Unavailable. The Server returned: ' + e.getMessage();
                    hasError = true;
                }
                catch(Exception ex){ // other exception 
                    errorMessage = 'Too many results. Please refine the criteria.';
                    hasError = true; // Used to display custom error messages; not <apex:pageMessages/>
                }
            }
            else{ // trial usage exceeded
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Exceeded 100 records limit'));
                showPage = false;
                hasError = false; // Used to display custom error messages; not <apex:pageMessages/>
            }
        }
        else { // No AddressSuggestion object available to call selectAddress()
            errorMessage = 'There was something wrong with the API call. If this error continues to occur please contact support@prm.com.au';
            hasError = true;
            system.debug(inputHiddenValue);
        }
        system.debug(phoneNumber);
        return NULL;
    }
    
    /* Work on AddressDetail item selected by user */
    public PageReference selectAddressDetail() {
        hasError = false;
        system.debug(inputHiddenValue);
        TotalCheckWebService.AddressDetail selectedAddressDetail = addressDetailMap.get(inputHiddenValue); // selected value sent here;
                                                                                                       // fetch from map corresponding AddressDetail instance
        system.debug(selectedAddressDetail);
        if(selectedAddressDetail == NULL){ // No AddressDetail object available
            errorMessage = 'There was something wrong with the API call. If this error continues to occur please contact support@prm.com.au';
            hasError = true;
            system.debug(inputHiddenValue);
        }
        else {
            // make sure to empty a string that might be actually null
            if(selectedAddressDetail.buildingName == NULL)
                selectedAddressDetail.buildingName = '';
            if(selectedAddressDetail.subPremise == NULL)
                selectedAddressDetail.subPremise = '';
            if(selectedAddressDetail.streetNumber == NULL)
                selectedAddressDetail.streetNumber = '';
            if(selectedAddressDetail.streetName == NULL)
                selectedAddressDetail.streetName = '';
            if(selectedAddressDetail.streetSuffix == NULL)
                selectedAddressDetail.streetSuffix = '';
            if(selectedAddressDetail.streetType == NULL)
                selectedAddressDetail.streetType = '';
            
            String pName = primaryName;
            String sName = secondaryName;
            String cName = company;
            Boolean PAFaddr = false;
            if(selectedAddressResult.primaryName != NULL && selectedAddressResult.primaryName.length() > 0) {
                if(TotalCheckConstants.LEAD_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)) && this.searchType == TotalCheckConstants.SEARCH_TYPE_BUSINESS)
                                company = selectedAddressResult.primaryName;
                            else
                                primaryName = selectedAddressResult.primaryName;
            }
            else { // No name was returned from WS. Reuse what user entered
                errorMessage = 'Not a WP address, therefore name not matched. Retained input name';
                hasError = true;
                PAFaddr = true;
            }
            
            secondaryName = selectedAddressResult.secondaryName;
            address = toProperCase(selectedAddressDetail.buildingName) + ' ' + toProperCase(selectedAddressDetail.subPremise) + ' ' + toProperCase(selectedAddressDetail.streetNumber) + ' ' + toProperCase(selectedAddressResult.streetName) + ' ' + toProperCase(selectedAddressResult.streetType) + ' ' + toProperCase(selectedAddressResult.streetSuffix);
            address = address.trim();
            suburb = selectedAddressDetail.suburb;
            state = selectedAddressDetail.state;
            postcode = selectedAddressDetail.postcode;
            if(selectedAddressResult.phoneNumber != null)
            {
                phoneNumber = selectedAddressResult.phoneNumber;
                if(phoneNumber != null)
                {
                    phoneNumber = phoneNumber.replaceAll('-',' ');
                    phoneNumber = phoneNumber.replaceAll('[()]','');
                }
            }
                        
            system.debug(phoneNumber);
            
            // capture selected address details 
            addressItemInstance = new AddressItem(); //clear out old values
            if(TotalCheckConstants.LEAD_ID_STARTS_WITH.equalsIgnoreCase(objId.substring(0, 3)) && this.searchType == TotalCheckConstants.SEARCH_TYPE_BUSINESS)
            {
                if(PAFaddr == false)
                    addressItemInstance.primaryName = company;
                else
                    addressItemInstance.primaryName = cName;
            }
            else 
            {
                if(PAFaddr == false)
                {
                    addressItemInstance.primaryName = primaryName;
                    addressItemInstance.secondaryName = secondaryName;
                }
                else
                {
                    addressItemInstance.primaryName = pName;
                    addressItemInstance.secondaryName = sName;
                }
            }
            addressItemInstance.buildingName = selectedAddressDetail.buildingName;
            addressItemInstance.subPremise = selectedAddressDetail.subPremise;
            addressItemInstance.street = address;
            addressItemInstance.suburb = suburb;
            addressItemInstance.state = state;
            addressItemInstance.postcode = postcode;
            if(PAFaddr == false)
                addressItemInstance.firstPhoneNumber = phoneNumber;
            addressItemInstance.streetNumber = selectedAddressDetail.streetNumber;
            addressItemInstance.streetName = selectedAddressDetail.streetName;
            addressItemInstance.streetType = selectedAddressDetail.streetType;
            addressItemInstance.bsp = selectedAddressDetail.bsp;
            addressItemInstance.dpid = selectedAddressDetail.dpid;
            //addressItemInstance.wplistingtype = selectedAddressDetail.wplistingtype;
            addressItemInstance.barcode = selectedAddressDetail.barcode;
            addressItemInstance.formattedAddress = address + ' <br/>' + suburb + ' ' + state + ' ' + postcode;
                        
            if(phoneNumber != NULL)
                addressItemInstance.phoneNumbers.add(phoneNumber);
            if(selectedAddressResult.alternativePhoneNumbers != NULL)
                addressItemInstance.phoneNumbers.addAll(selectedAddressResult.alternativePhoneNumbers);
            addressItemInstance.wpListingType = (selectedAddressResult.wpListingType != NULL)?selectedAddressResult.wpListingType:'';
            addressItemInstance.listSize = addressItemInstance.phoneNumbers.size();
            
            if(PAFaddr == false)
            {
                    if(objId == Schema.Sobjecttype.Account.getKeyPrefix())
                        {
                            primaryName = (addressItemInstance.primaryName == NULL)?'':addressItemInstance.primaryName;
                            secondaryName = (addressItemInstance.secondaryName == NULL)?'':addressItemInstance.secondaryName;
                            address = (addressItemInstance.street == NULL)?'':addressItemInstance.street;
                            suburb = (addressItemInstance.suburb == NULL)?'':addressItemInstance.suburb;
                            state = (addressItemInstance.state == NULL)?'':addressItemInstance.state;
                            postcode = (addressItemInstance.postcode == NULL)?'':addressItemInstance.postcode;
                            phoneNumber = '';
            
                            List<String> phoneNumberList = new List<String>(); // Needs to be List<> for indexing
                            phoneNumberList.addAll(addressItemInstance.phoneNumbers);
                            phoneNumber = phoneNumberList.isEmpty()?'':phoneNumberList[0];        
                        }
                        
                        else if(objId == Schema.Sobjecttype.Contact.getKeyPrefix())
                        {
                            primaryName = (addressItemInstance.primaryName == NULL)?'':addressItemInstance.primaryName;
                            secondaryName = (addressItemInstance.secondaryName == NULL)?'':addressItemInstance.secondaryName;
                            address = (addressItemInstance.street == NULL)?'':addressItemInstance.street;
                            suburb = (addressItemInstance.suburb == NULL)?'':addressItemInstance.suburb;
                            state = (addressItemInstance.state == NULL)?'':addressItemInstance.state;
                            postcode = (addressItemInstance.postcode == NULL)?'':addressItemInstance.postcode;
                            mobilePhoneNumber = findMobileNumber(addressItemInstance.phoneNumbers);
                            phoneNumber = '';
                            otherPhoneNumber = '';
                            if(mobilePhoneNumber != NULL)
                                addressItemInstance.phoneNumbers.remove(mobilePhoneNumber);
                            else
                                mobilePhoneNumber = '';
                            if(!addressItemInstance.phoneNumbers.isEmpty()) 
                            {
                                List<String> phoneNumberList = new List<String>(); // Needs to be List<> for indexing
                                phoneNumberList.addAll(addressItemInstance.phoneNumbers);
                                phoneNumber = phoneNumberList[0];
                                addressItemInstance.phoneNumbers.remove(phoneNumber);
                            }
        
                            if(!addressItemInstance.phoneNumbers.isEmpty()) {
                                List<String> phoneNumberList = new List<String>(); // Needs to be List<> for indexing
                                phoneNumberList.addAll(addressItemInstance.phoneNumbers);
                                otherPhoneNumber = phoneNumberList[0];
                                addressItemInstance.phoneNumbers.remove(otherPhoneNumber);
                            }
                            if(phoneNumber == mobilePhoneNumber)
                                phoneNumber = '';
        
                        }
                        
                        else if(objId == Schema.Sobjecttype.Lead.getKeyPrefix())
                        {
                            if(this.searchType == TotalCheckConstants.SEARCH_TYPE_BUSINESS)
                                company = (addressItemInstance.primaryName == NULL)?'':addressItemInstance.primaryName;
                            else
                            {
                                primaryName = (addressItemInstance.primaryName == NULL)?'':addressItemInstance.primaryName;
                                secondaryName = (addressItemInstance.secondaryName == NULL)?'':addressItemInstance.secondaryName;
                            }
                            address = (addressItemInstance.street == NULL)?'':addressItemInstance.street;
                            suburb = (addressItemInstance.suburb == NULL)?'':addressItemInstance.suburb;
                            state = (addressItemInstance.state == NULL)?'':addressItemInstance.state;
                            postcode = (addressItemInstance.postcode == NULL)?'':addressItemInstance.postcode;
                            mobilePhoneNumber = findMobileNumber(addressItemInstance.phoneNumbers);
                            phoneNumber = '';
            
                            if(mobilePhoneNumber != NULL) {
                                addressItemInstance.phoneNumbers.remove(mobilePhoneNumber);
                            }
                            else {
                                mobilePhoneNumber = '';
                            }
                            List<String> phoneNumberList = new List<String>(); // Needs to be List<> for indexing
                            phoneNumberList.addAll(addressItemInstance.phoneNumbers);
                            
                            if(!addressItemInstance.phoneNumbers.isEmpty()) {
                                phoneNumber = phoneNumberList[0];
                            }
                            if(phoneNumber == mobilePhoneNumber)
                                phoneNumber = '';
                        }
            }
        
        }         
                                                                          
        system.debug(phoneNumber);
        return NULL;
    }
    
    /* Reset everything on the page */
    public PageReference resetFields() {
        primaryName = '';
        secondaryName = '';
        company = '';
        address = '';
        suburb = '';
        state = '';
        postcode = '';
        country = '';
        address1 = '';
        suburb1 = '';
        state1 = '';
        postcode1 = '';
        country1 = '';
        phoneNumber = '';
        mobilePhoneNumber = '';
        otherPhoneNumber = '';
        errorMessage = '';
        inputHiddenValue = '';
        addressResultsJSONMap = '';
        hasError = false;
        hasNoNames = true;
        hasNoAddress = true;
        resultNames.clear();
        suggestedAddressesMap.clear();
        detailAddresses.clear();
        addressDetailMap.clear();
        addressItemInstance = new AddressItem();
        
        if(objId == Schema.Sobjecttype.Account.getKeyPrefix())
        {
            theAccount.ParentId = null;
            theAccount.AccountNumber = '';
            theAccount.Site = '';
            theAccount.Industry = '';
            theAccount.Sic = '';
            theAccount.AnnualRevenue = null;
            theAccount.NumberOfEmployees = null;
        }
            
        return NULL;
    }
    
    /* Cancel current operation. Go back to previous page */
    public PageReference goBack() {
        String str = Apexpages.currentPage().getParameters().get('retURL');
        str = (str != NULL)?EncodingUtil.urlDecode(str,TotalCheckConstants.URL_ENCODING):'/home/home.jsp';
        
        return new Pagereference(str);
    }
    
    /* Determine where to go based on user action/inputs */
    public PageReference createRecordPage() {
        
        if(objId == Schema.SObjectType.Account.getKeyPrefix())
            return createAccount();
        else if(objId == Schema.SObjectType.Contact.getKeyPrefix())
            return createContact();
        else if(objId == Schema.SObjectType.Lead.getKeyPrefix())
            return createLead();
        return NULL;
      
    }
    
    // Begin private methods 
    /* Returns first mobile number (begins with 04) found from a set of numbers or NULL */
    private String findMobileNumber(Set<String> phoneNumbers) {
        String mobileNumber = NULL;
        for(String pNumber : phoneNumbers) {
            system.debug(pNumber);
            
            if(pNumber != NULL && (pNumber.trim().startsWith('(04)') || pNumber.trim().startsWith('04'))) {
                mobileNumber = pNumber;
                break; // find only the first, get out of loop
            }
        }   
        
        return mobileNumber;
    }
    
    /* Returns string with first letter capitalized: value = 'HeLLo', returnValue = 'Hello'*/
    private String toProperCase(String value) {
        if(value == NULL)
            return '';
        else if(value.length() < 2 )
            return value.toUpperCase();
        
        String lowerStr = value.toLowerCase();
        String firstChar = value.substring(0, 1).toUpperCase();
        
        return firstChar + lowerStr.substring(1);
    }
    
    /* Reloads TotalCheck custom setting record */
    private void fetchCustomSetting() {
        // (re)fetches custom setting record and updates local instance
        tcApi = new TotalCheckAPIController();
        dataSet = tcApi.getTCCustomSetting();
    }
    
    /* Takes user to Lead edit page */
    private PageReference createLead(){
        theLead.lastname = primaryName;
        theLead.Phone = phoneNumber;
        theLead.MobilePhone = mobilePhoneNumber;
        theLead.Street = address;
        theLead.City = suburb;
        theLead.State = state;
        theLead.PostalCode = postcode;
        theLead.Country = country;
        theLead.Company = company;
        if(addressItemInstance.wpListingType == TotalCheckConstants.SEARCH_TYPE_RESIDENTIAL || searchType == TotalCheckConstants.SEARCH_TYPE_RESIDENTIAL) {
            theLead.lastname = primaryName;
            //theLead.firstname = secondaryName;
        }
        theLead.ttlchk_BSP__c = addressItemInstance.bsp;
        theLead.ttlchk_DPID__c = addressItemInstance.dpid;
        theLead.ttlchk_Barcode__c = addressItemInstance.barcode;
        theLead.ttlchk_searchType__c = searchType;
        Database.upsertResult uResult = Database.upsert(theLead,false);
        if(uResult.isSuccess())
        {
            PageReference pr = new Pagereference('/'+uResult.getId());
            return pr;
        }
        errorMessage = uResult.getErrors()[0].getMessage();
        hasError = true;
        return NULL;
       
       }
    
    /* Takes user to Account edit page */
    private PageReference createAccount(){
        
        theAccount.name = primaryName;
        theAccount.BillingStreet = address;
        theAccount.BillingCity = suburb;
        theAccount.BillingState = state;
        theAccount.BillingPostalCode = postcode;
        theAccount.BillingCountry = country;
        theAccount.Phone = phoneNumber;
        theAccount.ShippingStreet = address1;
        theAccount.ShippingCity = suburb1;
        theAccount.ShippingState = state1;
        theAccount.ShippingPostalCode = postcode1;
        theAccount.ShippingCountry = country1;
        theAccount.ttlchk_BSP__c = addressItemInstance.bsp;
        theAccount.ttlchk_DPID__c = addressItemInstance.dpid;
        theAccount.ttlchk_Barcode__c = addressItemInstance.barcode;
        Database.upsertResult uResult = Database.upsert(theAccount,false);
        if(uResult.isSuccess())
        {
            PageReference pr = new Pagereference('/'+uResult.getId());
            return pr;
        }
        errorMessage = uResult.getErrors()[0].getMessage();
        hasError = true;
        return NULL;
        
    }
    
    /* Takes user to Contact edit page */
    private PageReference createContact(){

        theContact.lastname = primaryName;
        //theContact.firstname = secondaryName;
        theContact.MailingStreet = address;
        theContact.MailingCity = suburb;
        theContact.MailingState = state;
        theContact.MailingPostalCode = postcode;
        theContact.MailingCountry = country;
        theContact.OtherStreet = address1;
        theContact.OtherCity = suburb1;
        theContact.OtherState = state1;
        theContact.OtherPostalCode = postcode1;
        theContact.OtherCountry = country1;
        theContact.Phone = phoneNumber;
        theContact.MobilePhone = mobilePhoneNumber;
        theContact.OtherPhone = otherPhoneNumber;
        theContact.ttlchk_BSP__c = addressItemInstance.bsp;
        theContact.ttlchk_DPID__c = addressItemInstance.dpid;
        theContact.ttlchk_Barcode__c = addressItemInstance.barcode;
        Database.upsertResult uResult = Database.upsert(theContact,false);
        if(uResult.isSuccess())
        {
            PageReference pr = new Pagereference('/'+uResult.getId());
            return pr;
        }
        errorMessage = uResult.getErrors()[0].getMessage();
        hasError = true;
        return NULL;
        
    }
    
    private Boolean compareTimestamps(Long incoming) {
        if(lastTimeStamp == NULL || lastTimeStamp < incoming) { // first call, or new call 
            lastTimeStamp = incoming;
            Long currentTimestamp = system.now().getTime();
            system.debug('lastTimeStamp set ' + currentTimestamp);
            return true;
            }
        else
            return false;
    }
    
    public void copyAddress(){
        
        if(objId == Schema.Sobjecttype.Account.getKeyPrefix())
        {
            address1 = address;         
            suburb1 = suburb;
            state1 = state;
            postcode1 = postcode;
            country1 = country;
        }
        else if(objId == Schema.Sobjecttype.Contact.getKeyPrefix())
        {
            address1 = address;         
            suburb1 = suburb;
            state1 = state;
            postcode1 = postcode;
            country1 = country;
        }
                
        
    }
    
    // Begin inner classes
    /**
    * Inner class to store address details
    * Address information comes from a few objects
    * An instance of this inner class is used to collate information into a single place which can be passed around
    *
    * Author: vidhyashankar@prm.com.au
    */
    public class AddressItem {
        public String primaryName {get;set;}
        public String secondaryName {get;set;}
        public String buildingName {get;set;}
        public String subPremise {get;set;}
        public String street {get;set;}
        public String streetNumber {get;set;}
        public String streetName {get;set;}
        public String streetType {get;set;}
        public String suburb {get;set;}
        public String state {get;set;}
        public String postcode {get;set;}
        public String bsp{get;set;}
        public String dpid{get;set;}
        public String barCode {get;set;}
        public String firstPhoneNumber {get; set;}
        public String formattedAddress {get; set;}
        public Set<String> phoneNumbers {get; private set;}
        public String wpListingType {get; private set;}
        public Integer listSize{get;private set;}
        
        /* Tries to give the full name if available [primary name + secondary name] or just the primary (last) name */
        public String getName() {
            String name = primaryName;
            if(secondaryName != NULL && secondaryName != '')
                name += ' ' + secondaryName;
            
            return name;
        }
        
        /* Default constructor*/
        public AddressItem() {
            primaryName = '';
            secondaryName = '';
            buildingName = '';
            subPremise = '';
            street = '';
            streetNumber = '';
            streetName = '';
            streetType = '';
            suburb = '';
            state = '';
            postcode = '';
            bsp = '';
            dpid = '';
            wpListingType = '';
            barCode = '';
            firstPhoneNumber = '';
            phoneNumbers = new Set<String>();
            wpListingType = '';
            formattedAddress = '';
            listSize = 0;
        }
    }
}