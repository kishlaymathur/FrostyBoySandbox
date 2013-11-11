/**
 * Controller for LeadRedirect page
 * 
 */
public with sharing class LeadRedirectController {
    
    public LeadRedirectController(Apexpages.standardController controller){
        
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
        
        for(String key : parameters.keySet()){ // Construct query parameters
            str = str + key + '=' + EncodingUtil.urlEncode(parameters.get(key), 'UTF-8') + '&';
        }
        System.debug('str'+str);
        
        if(isTrialUser && usageCnt >= 100)
            PR = new PageReference('/' + TotalCheckConstants.LEAD_ID_STARTS_WITH + '/e?'+str);
        else // Goes to TotalCheck page
            PR = new PageReference('/apex/TotalCheckPage?'+str+'objId=' + TotalCheckConstants.LEAD_ID_STARTS_WITH);
            
        return PR;
    }
}