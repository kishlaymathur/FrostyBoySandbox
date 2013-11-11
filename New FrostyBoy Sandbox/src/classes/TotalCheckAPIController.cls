/**
 * This Class acts as a Controller for TotalCheckAPI page.
 * Also provides methods to access the protected Custom Setting which stores TotalCheck API credentials, number of records fetched etc.
 *
 */

public with sharing class TotalCheckAPIController {
        // Begin public variables-properties
    public String username {get; set;}
    public String password1 {get; set;}
    public String password2 {get; set;}
    public String promoCode {get; set;}
    
    // Begin private variables-properties 
    private Boolean isDirty {get; set;}
    private TotalCheckConnector__c dataSet {get; set;}
    private ApexPages.Severity severity;
    private String errorMessage;
    
    // Begin public properties
    
    public Boolean getPromoCodeFieldEditable() {
        // Enable Promo Code field if it was not used previously and the user is a trial user
        return !dataSet.Used_Promocode__c && dataSet.Trial_User__c;
    }
    
    /* Current number of records fetched */
    public Integer getUsageCount() {
        return Integer.valueOf(dataSet.TCUsageCount__c);
    }
    
    // Begin public constructors
    
    public TotalCheckAPIController () { // Constructor allows access to Custom Setting like a singleton class
        dataSet = TotalCheckConnector__c.getValues('TotalCheckStore');
        isDirty = false;
        if(dataSet == NULL) { // Custom setting doesn't exist; create new with default values
            dataSet = new TotalCheckConnector__c(Name = 'TotalCheckStore'); 
            dataSet.TCUsageCount__c = 0;
            dataSet.TCUsername__c = 'sales_tc_prod'; // Hard code trial credentials
            dataSet.TCPassword__c = 'Sales_001';
            dataSet.Trial_User__c = true;
            dataSet.Used_Promocode__c = false;
            
            isDirty = true;
            }
        else {
            //username = dataSet.TCUsername__c;
            isDirty = false;
            }
        }
    
    // Begin private methods
    
    /* Method to update or insert the custom setting instance. */
    private void saveCustomSetting() {
        Database.Saveresult sr;
        
        if(isDirty) { // custom setting was modified
            if(dataSet.Id != NULL)
                sr = Database.update(dataSet);
            else
                sr = Database.insert(dataSet);
                
            isDirty = !sr.isSuccess(); 
        }       
    }
    
    /* Method checks if credentials entered are valid or not by making a sample API call */
    private Boolean testWSCredentials(String username, String password) {
        TotalCheckWebService.TotalCheckServiceImplPort ws = new TotalCheckWebService.TotalCheckServiceImplPort(username, password);
        Boolean isSuccess = false;
        
        try {
            if(!Test.isRunningTest()) {
                List<String> suggestNames = ws.suggestNames('Residential', 'John'); // Make a sample search
            }
            isSuccess = true;
        }
        catch(Exception ex){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Could not validate the credentials you entered. Please try again'));
            system.debug(ex);
            isSuccess = false; // Search failed
        }
        
        return isSuccess;
    }
    
    // Begin public methods
    
    /* User save action */
    public PageReference save() {
        Boolean hasMessages = false;
        
        if((username == NULL || username == '') && (promoCode == NULL || promoCode == '')) { // Nothing is entered
            severity = ApexPages.Severity.ERROR;
            errorMessage = 'Please enter API credentials or promo code';
            hasMessages = true;
        }
        else if(!(promoCode == NULL || promoCode == '')) { // promo code is entered
            system.debug('promo code entered');
            if(promoCode.equals('SENSISPROMO100') && dataSet.Used_Promocode__c == false) { // make sure promocode wasn't used before 
                dataSet.Used_Promocode__c = true; // make sure promocode is used only once
                dataSet.TCUsageCount__c = 0;
                isDirty = true;
                severity = ApexPages.Severity.INFO;
                        errorMessage = 'Promo code applied successfully';
                        hasMessages = true;
            }
            else {
                severity = ApexPages.Severity.ERROR;
                errorMessage = 'You\'ve either used this promocode before or its no longer valid';
                hasMessages = true;
            }
        }
        else if(password1 == NULL || password1 == '') { // no password entered
            severity = ApexPages.Severity.ERROR;
                errorMessage =  'Please enter a valid password';
                hasMessages = true;
        }
        else if(password1.equals(password2)) { // passwords are equal
            system.debug('username password entered');
            if(testWSCredentials(username, password1)) { // Validate credentials with WS right away
                dataSet.TCUsername__c = username;
                dataSet.TCPassword__c = password1;
                dataSet.TCUsageCount__c = 0;
                dataSet.Trial_User__c = false;
                dataSet.Used_Promocode__c = false;
                isDirty = true;
                severity = ApexPages.Severity.INFO;
                        errorMessage = 'New Credentials saved successfully';
                        hasMessages = true;
            }
            else
                hasMessages = false;
        }   
        else { // Passwords do not match
            severity = ApexPages.Severity.ERROR;
                errorMessage =  'Passswords do not match';
                hasMessages = true;
        }
        
        // Save the custom setting instance
        saveCustomSetting();
        
        if(isDirty) {
                severity = ApexPages.Severity.ERROR;
                errorMessage = 'Error saving your settings. Please try again later.';
        }
        if(Apexpages.hasMessages())
                Apexpages.getMessages().clear(); // Clear any existing messages
                
        if(hasMessages)// make sure we have a valid message to show
                Apexpages.addMessage(new ApexPages.Message(severity, errorMessage));
        
        return NULL;
        }
    
    /* User cancel action */
    public PageReference cancel() { // Go home; no where else to go
        PageReference pr = new Pagereference('/home/home.jsp');
        return pr;
        }
    
    /* Always use this to access the Custom Setting from outside the scope of this class*/
    public TotalCheckConnector__c getTCCustomSetting() {
        if(isDirty)
                saveCustomSetting(); // Commit custom setting to DB before sending out; DML operation not allowed in constructor
        
        return dataSet;
    }
}