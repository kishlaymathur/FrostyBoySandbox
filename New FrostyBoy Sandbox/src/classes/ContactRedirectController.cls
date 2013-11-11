/**
 * Controller for ContactRedirect page
 * 
 */
public with sharing class ContactRedirectController {

    public ContactRedirectController(Apexpages.standardController controller){
        
    }
    
    public PageReference gotoTotalCheckPage(){
        Map<String,String> parameters = Apexpages.currentPage().getParameters();
        System.debug(parameters);
        parameters.put('nooverride', '1');  // Avoid ininite loop of redirects
        String str2 = parameters.remove('save_new'); // Avoid auto save when going Standard Account edit page
        String str = '';
        PageReference PR;
        TotalCheckAPIController tcApi = new TotalCheckAPIController(); // Get a copy of TotalCheck API credentials
        TotalCheckConnector__c dataSet = tcApi.getTCCustomSetting();
        Integer usageCnt = Integer.valueOf(dataSet.TCUsageCount__c);
        Boolean isTrialUser = dataSet.Trial_User__c;
        
        for(String key : parameters.keySet()){ // construct query string parameters
            str = str + key + '=' + EncodingUtil.urlEncode(parameters.get(key), 'UTF-8') + '&';
        }
        System.debug('str'+str);
        
        if(isTrialUser && usageCnt >= 100)
            PR = new PageReference('/' + TotalCheckConstants.CONTACT_ID_STARTS_WITH + '/e?'+str);
        else // Goes to TotalCheck page
            PR = new PageReference('/apex/TotalCheckPage?'+str+'objId=' + TotalCheckConstants.CONTACT_ID_STARTS_WITH);
            
        return PR;
    }   
}