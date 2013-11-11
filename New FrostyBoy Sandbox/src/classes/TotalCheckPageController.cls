/**
* Controller for TotalCheck page
* Makes web service calls, updates records fetched count, controls usage of page based on this
* 
*/

public with sharing class TotalCheckPageController {
    // Begin public variable-properties
    public String primaryName {get; set;}
    public String secondaryName {get; set;}
    public String address {get; set;}
    public String suburb {get; set;}
    public String state {get; set;}
    public String postcode {get; set;}
    public String phoneNumber {get; set;}
    public String searchType {get; set;}
    public String inputHiddenValue {get;set;}
    public String errorMessage {get;set;}
    public Boolean hasError {get;set;}
    public Boolean hasDetailList {get; set;}
    public Boolean isValidate {get; private set;} // Don't allow to be set via the page
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
    
    // Begin private variables
    private String objId {get; set;}
    private TotalCheckConnector__c dataSet {get; set;}
    private TotalCheckAPIController tcApi {get; set;}
    private TotalCheckWebService.TotalCheckServiceImplPort ws {get; set;}
    private Map<String, TotalCheckWebService.AddressSuggestion> suggestedAddressesMap {get; set;}
    private Map<String, TotalCheckWebService.AddressDetail> addressDetailMap {get; set;}
    private Long lastTimeStamp {get; set;}
    
    // Begin public properties
    /* Determine if usage count is to be shown on page based on user licence */
    public Boolean getShowUsageCount() {
        return dataSet.Trial_User__c;
    }
    
    // Begin Constructors
    
    /* Default constructor */
    public TotalCheckPageController(){
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
        if(isValidate) {
            // bind fields to values passed in
            primaryName = (tName != NULL)?tName:'';
            address = (tAddress != NULL)?tAddress:'';
            suburb = (tSuburb != NULL)?tSuburb:'';
            state = (tState != NULL)?tState:'';
            postcode = (tPostcode != NULL)?tPostcode:'';
            //phoneNumber = (tPhoneNumber != NULL)?tPhoneNumber:'';
        }
        else {
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
    }
    
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
        searchTypes.add(new SelectOption(TotalCheckConstants.SEARCH_TYPE_RESIDENTIAL, 'Residential')); 
        searchTypes.add(new SelectOption(TotalCheckConstants.SEARCH_TYPE_BUSINESS, 'Business/Government')); 
        searchTypes.add(new SelectOption(TotalCheckConstants.SEARCH_TYPE_ALL, 'All')); 
        
        return searchTypes; 
    }
        
    /* Look for names based on partial user input for name */
    public PageReference searchNames(){
        // calls suggestNames method of the web service
        resultNames.clear();
        hasNoNames = true;
        // update credentials etc from custom setting; might have changed from other page requests 
        fetchCustomSetting();
        usageCount = Integer.valueOf(dataSet.TCUsageCount__c);
        if(!dataSet.Trial_User__c || usageCount < 100){ // Check usage limit only for trial users
            try{
                List<String> suggestNames = ws.suggestNames(searchType, primaryName); // make the call
                
                if(suggestNames == NULL)
                    suggestNames = new List<String>();
                for(String name : suggestNames){
                    name = String.escapeSingleQuotes(name);
                    // prefix, suffix with "'" as this will be rendered directly as JSON array on page
                    resultNames.add('\'' + name + '\'');
                    hasNoNames = false;
                }
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
                search.name = primaryName;
                search.searchType = searchType;
                search.formattedAddress = address;
                search.suburb = suburb;
                search.state = state;
                search.postcode = postcode;
                search.phoneNumber = phoneNumber;
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
                        errorMessage = 'There was something wrong with the API call. If this error continues to occur please contact support@prmaustralia.com.au';
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
                            
                        // Do not empty name if WS returns null
                        if(selectedAddressResult.primaryName != NULL && selectedAddressResult.primaryName.length() > 0) {
                            primaryName = selectedAddressResult.primaryName;
                        }
                        else { // No name was returned from WS. Reuse what user entered
                            errorMessage = 'Not a White Pages® address, therefore name not matched. Retained input name';
                            hasError = true;
                        }
                        
                        secondaryName = selectedAddressResult.secondaryName;
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
                        addressItemInstance.primaryName = primaryName;
                        addressItemInstance.secondaryName = secondaryName;
                        addressItemInstance.buildingName = selectedAddressResult.buildingName;
                        addressItemInstance.subPremise = selectedAddressResult.subPremise;
                        addressItemInstance.street = address;
                        addressItemInstance.suburb = suburb;
                        addressItemInstance.state = state;
                        addressItemInstance.postcode = postcode;
                        addressItemInstance.firstPhoneNumber = phoneNumber;
                        addressItemInstance.streetNumber = selectedAddressResult.streetNumber;
                        addressItemInstance.streetName = selectedAddressResult.streetName;
                        addressItemInstance.streetType = selectedAddressResult.streetType;
                        addressItemInstance.dpid = selectedAddressResult.dpid;
                        //addressItemInstance.wplistingtype = selectedAddressResult.wplistingtype;
                        addressItemInstance.barcode = selectedAddressResult.barcode;
                        addressItemInstance.formattedAddress = address + ' <br/>' + suburb + ' ' + state + ' ' + postcode;
                            
                        if(phoneNumber != NULL)
                            addressItemInstance.phoneNumbers.add(phoneNumber);
                        if(selectedAddressResult.alternativePhoneNumbers != NULL)
                            addressItemInstance.phoneNumbers.addAll(selectedAddressResult.alternativePhoneNumbers);
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
                        
                        // Update usage count
                        dataSet.TCUsageCount__c++;
                        usageCount = Integer.valueOf(dataSet.TCUsageCount__c);
                        
                        update dataSet;
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
            errorMessage = 'There was something wrong with the API call. If this error continues to occur please contact support@prmaustralia.com.au';
            hasError = true;
            system.debug(inputHiddenValue);
        }
        
        return NULL;
    }
    
    /* Work on AddressDetail item selected by user */
    public PageReference selectAddressDetail() {
        system.debug(inputHiddenValue);
        TotalCheckWebService.AddressDetail selectedAddressDetail = addressDetailMap.get(inputHiddenValue); // selected value sent here;
                                                                                                       // fetch from map corresponding AddressDetail instance
        system.debug(selectedAddressDetail);
        if(selectedAddressDetail == NULL){ // No AddressDetail object available
            errorMessage = 'There was something wrong with the API call. If this error continues to occur please contact support@prmaustralia.com.au';
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
                
            if(selectedAddressResult.primaryName != NULL && selectedAddressResult.primaryName.length() > 0) {
                primaryName = selectedAddressResult.primaryName;
            }
            else { // No name was returned from WS. Reuse what user entered
                errorMessage = 'Not a WP address, therefore name not matched. Retained input name';
                hasError = true;
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
            addressItemInstance.primaryName = primaryName;
            addressItemInstance.secondaryName = secondaryName;
            addressItemInstance.buildingName = selectedAddressDetail.buildingName;
            addressItemInstance.subPremise = selectedAddressDetail.subPremise;
            addressItemInstance.street = address;
            addressItemInstance.suburb = suburb;
            addressItemInstance.state = state;
            addressItemInstance.postcode = postcode;
            addressItemInstance.firstPhoneNumber = phoneNumber;
            addressItemInstance.streetNumber = selectedAddressDetail.streetNumber;
            addressItemInstance.streetName = selectedAddressDetail.streetName;
            addressItemInstance.streetType = selectedAddressDetail.streetType;
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
        }                                                                                      
        
        return NULL;
    }
    
    /* Reset everything on the page */
    public PageReference resetFields() {
        primaryName = '';
        address = '';
        suburb = '';
        state = '';
        postcode = '';
        phoneNumber = '';
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
        Map<String,String> parameters = Apexpages.currentPage().getParameters();
        String objIdSx = objId.substring(0, 3); // sobjectid suffix decides sobject type
        String str = '';
        Pagereference pr = NULL;
        
        // these are some of the default parameters that come in automatically
        if(parameters.containsKey(TotalCheckConstants.RETURN_URL_KEY)) // Return URL
            str += TotalCheckConstants.RETURN_URL_KEY + '=' + parameters.get(TotalCheckConstants.RETURN_URL_KEY) + '&';
        if(parameters.containsKey(TotalCheckConstants.OBJECT_TYPE_KEY)) // sObject type; apprears when record type is selected
            str += TotalCheckConstants.OBJECT_TYPE_KEY + '=' + parameters.get(TotalCheckConstants.OBJECT_TYPE_KEY) + '&';
        if(parameters.containsKey(TotalCheckConstants.RECORD_TYPE_KEY)) // record type; apprears when record type is selected
            str += TotalCheckConstants.RECORD_TYPE_KEY + '=' + parameters.get(TotalCheckConstants.RECORD_TYPE_KEY) + '&';
        
        if(objIdSx.equalsIgnoreCase(TotalCheckConstants.LEAD_ID_STARTS_WITH) == true) { // Leads
            pr = goToLeadPage(str);
        }
        else if(objIdSx.equalsIgnoreCase(TotalCheckConstants.ACCOUNT_ID_STARTS_WITH) == true) { // Accounts/Personal Accounts
            pr = goToAccountPage(str);
        }
        else if(objIdSx.equalsIgnoreCase(TotalCheckConstants.CONTACT_ID_STARTS_WITH) == true) { // Contacts
            pr = goToContactPage(str);
        }
        
        return pr;
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
    private PageReference goToLeadPage(String str){
        // URL encode everything before passing 
        String primaryName = (addressItemInstance.primaryName == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.primaryName, TotalCheckConstants.URL_ENCODING);
        String secondaryName = (addressItemInstance.secondaryName == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.secondaryName, TotalCheckConstants.URL_ENCODING);
        String street = (addressItemInstance.street == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.street, TotalCheckConstants.URL_ENCODING);
        String suburb = (addressItemInstance.suburb == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.suburb, TotalCheckConstants.URL_ENCODING);
        String state = (addressItemInstance.state == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.state, TotalCheckConstants.URL_ENCODING);
        String postcode = (addressItemInstance.postcode == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.postcode, TotalCheckConstants.URL_ENCODING);
        String mobilePhoneNumber = findMobileNumber(addressItemInstance.phoneNumbers);
        system.debug(mobilePhoneNumber);
        String phoneNumber = '';
        
        if(mobilePhoneNumber != NULL) {
            addressItemInstance.phoneNumbers.remove(mobilePhoneNumber);
            mobilePhoneNumber = EncodingUtil.urlEncode(mobilePhoneNumber, TotalCheckConstants.URL_ENCODING);
        }
        else {
            mobilePhoneNumber = '';
        }
        List<String> phoneNumberList = new List<String>(); // Needs to be List<> for indexing
        phoneNumberList.addAll(addressItemInstance.phoneNumbers);
        
        if(!addressItemInstance.phoneNumbers.isEmpty()) {
            phoneNumber = phoneNumberList[0];
        }
        
        if(isValidate && (addressItemInstance.primaryName == NULL || addressItemInstance.primaryName == ''))
            str = '/' + objId + '/e?nooverride=1';
        else
        {
            // construct relative url with query string parameters
            str = '/' + objId + '/e?nooverride=1&' + str + 'lea8=' + phoneNumber + '&lea9='+ mobilePhoneNumber + '&lea16street='+street+'&lea16city='+suburb+'&lea16state='+state+'&lea16zip='+postcode;
            if(addressItemInstance.wpListingType == TotalCheckConstants.SEARCH_TYPE_RESIDENTIAL || searchType == TotalCheckConstants.SEARCH_TYPE_RESIDENTIAL) {
                // type of result can be empty sometimes; if so, check value selected from radio button on totalcheck page. NOT realiable as user can change it
                str += '&name_lastlea2='+primaryName;
            }
            else {// Business.
                str += '&lea3='+primaryName;
            }
        }
        System.debug('str'+str);
        PageReference pr = new Pagereference(str);
        return pr; // go to Lead edit page
    }
    
    /* Takes user to Account edit page */
    private PageReference goToAccountPage(String str){
        String primaryName = (addressItemInstance.primaryName == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.primaryName, TotalCheckConstants.URL_ENCODING);
        String secondaryName = (addressItemInstance.secondaryName == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.secondaryName, TotalCheckConstants.URL_ENCODING);
        String street = (addressItemInstance.street == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.street, TotalCheckConstants.URL_ENCODING);
        String suburb = (addressItemInstance.suburb == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.suburb, TotalCheckConstants.URL_ENCODING);
        String state = (addressItemInstance.state == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.state, TotalCheckConstants.URL_ENCODING);
        String postcode = (addressItemInstance.postcode == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.postcode, TotalCheckConstants.URL_ENCODING);
        String phoneNumber = '';
        
        List<String> phoneNumberList = new List<String>(); // Needs to be List<> for indexing
        phoneNumberList.addAll(addressItemInstance.phoneNumbers);
        phoneNumber = phoneNumberList.isEmpty()?'':phoneNumberList[0];        
        
        if(isValidate && (addressItemInstance.primaryName == NULL || addressItemInstance.primaryName == ''))
            str = '/' + objId + '/e?nooverride=1';
        else
        {
            // construct relative url with query string parameters
            str = '/' + objId + '/e?nooverride=1&'+str+'acc2='+ primaryName + '&acc10='+phoneNumber+'&acc17street='+street+'&acc17city='+suburb+'&acc17state='+state+'&acc17zip='+postcode;
            // Add fields for Person Account
            str += '&name_firstacc2=' + primaryName + '&PersonMailingAddressstreet=' + street + '&PersonMailingAddresscity=' + suburb + '&PersonMailingAddressstate=' + state + '&PersonMailingAddresszip=' + postcode;
        }
        System.debug('str'+str);
        PageReference pr = new Pagereference(str);
        return pr; // go to Account edit page
    }
    
    /* Takes user to Contact edit page */
    private PageReference goToContactPage(String str){
        String primaryName = (addressItemInstance.primaryName == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.primaryName, TotalCheckConstants.URL_ENCODING);
        String secondaryName = (addressItemInstance.secondaryName == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.secondaryName, TotalCheckConstants.URL_ENCODING);
        String street = (addressItemInstance.street == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.street, TotalCheckConstants.URL_ENCODING);
        String suburb = (addressItemInstance.suburb == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.suburb, TotalCheckConstants.URL_ENCODING);
        String state = (addressItemInstance.state == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.state, TotalCheckConstants.URL_ENCODING);
        String postcode = (addressItemInstance.postcode == NULL)?'':EncodingUtil.urlEncode(addressItemInstance.postcode, TotalCheckConstants.URL_ENCODING);
        String mobilePhoneNumber = findMobileNumber(addressItemInstance.phoneNumbers);
        String phoneNumber = '';
        String otherPhoneNumber = '';
        system.debug(mobilePhoneNumber);
        if(mobilePhoneNumber != NULL) {
            addressItemInstance.phoneNumbers.remove(mobilePhoneNumber);
            mobilePhoneNumber = EncodingUtil.urlEncode(mobilePhoneNumber, TotalCheckConstants.URL_ENCODING);
        }
        else {
            mobilePhoneNumber = '';
        }
        
        if(!addressItemInstance.phoneNumbers.isEmpty()) {
            List<String> phoneNumberList = new List<String>(); // Needs to be List<> for indexing
            phoneNumberList.addAll(addressItemInstance.phoneNumbers);
            phoneNumber = phoneNumberList[0];
            addressItemInstance.phoneNumbers.remove(phoneNumber);
            phoneNumber = EncodingUtil.urlEncode(phoneNumber, TotalCheckConstants.URL_ENCODING);
        }
        
        if(!addressItemInstance.phoneNumbers.isEmpty()) {
            List<String> phoneNumberList = new List<String>(); // Needs to be List<> for indexing
            phoneNumberList.addAll(addressItemInstance.phoneNumbers);
            otherPhoneNumber = phoneNumberList[0];
            addressItemInstance.phoneNumbers.remove(otherPhoneNumber);
            otherPhoneNumber = EncodingUtil.urlEncode(otherPhoneNumber, TotalCheckConstants.URL_ENCODING);
        }
        
        if(isValidate && (addressItemInstance.primaryName == NULL || addressItemInstance.primaryName == ''))
            str = '/' + objId + '/e?nooverride=1';
        else
        {
            str = '/' + objId + '/e?nooverride=1&' + str + 'con14=' + otherPhoneNumber +  '&con12=' + mobilePhoneNumber + '&con10=' + phoneNumber + '&con19street=' + street + '&con19city=' + suburb + '&con19state=' + state + '&con19zip=' + postcode;
            
            // construct relative url with query string parameters
            if(addressItemInstance.wpListingType == TotalCheckConstants.SEARCH_TYPE_RESIDENTIAL || searchType == TotalCheckConstants.SEARCH_TYPE_RESIDENTIAL) {
                // type of result can be empty sometimes; if so, check value selected from radio button on totalcheck page. NOT realiable as user can change it
                str += '&name_lastcon2=' + primaryName;
            }
            else {// Business. Can be empty if listing was not found in WhitePages
                str += '&con4=' + EncodingUtil.urlEncode(addressItemInstance.getName(), TotalCheckConstants.URL_ENCODING);
            }
        }
        System.debug('str'+str);
        PageReference pr = new Pagereference(str);
        return pr; // go to Contact edit page
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
    
    // Begin inner classes
    /**
    * Inner class to store address details
    * Address information comes from a few objects
    * An instance of this inner class is used to collate information into a single place which can be passed around
    *
    * Author: vidhyashankar@prmaustralia.com.au
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