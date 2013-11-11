global class FB_MapsByDistributorController 
{

    public FB_MapsByDistributorController(ApexPages.StandardController controller) 
    {
         selectedValue = ApexPages.currentPage().getParameters().get('id');
         Account a = [select Name from Account where Id=:selectedValue];
         Name = a.Name;
    }

    public PageReference BackToAccount()
    {
        selectedValue1 = ApexPages.currentPage().getParameters().get('id');
        //system.assertEquals('a',selectedvalue1);
        PageReference pageRef = new PageReference('/'+selectedValue1);
        return pageRef;
    }
    
     public PageReference Go() 
     {
        selectedValue = ApexPages.currentPage().getParameters().get('id');
        //System.assertEquals(selectedValue,null);
        return null;
     }
    
    @RemoteAction
    global static List<String> getAddresses(Boolean actv,Boolean inactv,Boolean lea,String recordId) 
    {
        //selectedValue = ApexPages.currentPage().getParameters().get('id');
        //System.assertEquals(recordId,null);
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
        //List<Account> acc = [select Id,Name,BillingStreet,BillingCity,BillingState,BillingCountry,Account_Status__c from Account where ParentId=:recordId AND Account_Status__c IN :statusesToQuery];
        //system.assertEquals(acc,null);
        for(Account a: [select Id,Name,BillingStreet,BillingCity,BillingState,BillingCountry,Account_Status__c,Type from Account where (ParentId=:recordId Or Id = :recordId) AND Account_Status__c IN :statusesToQuery] )
        {
            String addr =   '' ;
            String markerColor = '';
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
            if(a.Account_Status__c == 'Lead'){
                markerColor = 'Yellow';
            }
            else if(a.Account_Status__c == 'Active'){
                markerColor = 'Green';
            }
            else{
                markerColor = 'Red';
            }
            if(a.Type == 'Distributor'){
                markerColor = 'Blue';
            }
            listOfAddresses.add(String.escapeSingleQuotes(addr) + '#;' + String.escapeSingleQuotes(a.Name) + '#;' + markerColor + '#;' + a.Id);
        }
            
           //system.assertEquals(listOfAddresses,null);
        return listOfAddresses ;
    }
    
    public  String selectedValue{get;set;}
    public static Boolean isActive{get;set;}
    public static Boolean isNotActive{get;set;}
    public static Boolean isLead{get;set;}
    public String selectedValue1{get;set;}
    public String Name{get;set;}
    public List<Account> listOfParentAccount{get;set;}
    public List<String> listOfAddresses{get;set;}
         
}