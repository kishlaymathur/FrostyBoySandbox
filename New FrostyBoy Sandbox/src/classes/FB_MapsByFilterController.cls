global class FB_MapsByFilterController 
{
    
    public String selectedValue{get;set;}
    public List<Account> listOfParentAccount{get;set;}
    public List<String> listOfAddress{get;set;}
    public static Boolean isActive{get;set;}
    public static Boolean isNotActive{get;set;}
    public static Boolean isLead{get;set;}
    public List<SelectOption> getItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('WA','WA')) ;
        options.add(new SelectOption('VIC','VIC')) ;
        options.add(new SelectOption('TAS','TAS')) ;
        options.add(new SelectOption('SA','SA')) ;
        options.add(new SelectOption('QLD','QLD')) ;
        options.add(new SelectOption('NT','NT')) ;
        options.add(new SelectOption('NSW','NSW')) ;
        return options;
    }
    public PageReference Go() 
    {
        return null;
    }
    
    @RemoteAction
    global static List<String> getAddresses(String selectedSate,Boolean actv,Boolean inactv,Boolean lea) {
        //System.assertEquals(actv+' '+inactv+' '+lea,null);
        List<String> listOfAddresses = new List<String>();
        List<String> statusesToQuery = new List<String>();
            if(actv)
            {
                statusesToQuery.add('Active');
            }
        if(inactv){
                statusesToQuery.add('Inactive');
        }
        if(lea){
                statusesToQuery.add('Lead');
        }
        for(Account a: [select Id,Name,BillingStreet,BillingCity,BillingState,BillingCountry,Account_Status__c from Account where BillingState=:selectedSate AND Account_Status__c IN :statusesToQuery] )
        {
            String addr =   '' ;
            if(a.BillingStreet != null){
                addr = a.BillingStreet;
            }
            if(a.BillingCity != null){
                addr = addr + ' ' + a.BillingCity;
            }
            if(a.BillingState != null){
                addr = addr + ' ' + a.BillingState;
            }
            if(a.BillingCountry != null){
                addr = addr + ' ' + a.BillingCountry;
            }
            listOfAddresses.add(String.escapeSingleQuotes(addr) + '#;' + String.escapeSingleQuotes(a.Name) + '#;' + a.Account_Status__c + '#;' + a.Id);
        }
            
            //system.assertEquals(listOfAddresses,null);
        return listOfAddresses ;
    }

    

        
}