public class FB_selectAccountsController 
{

    

    public Decimal actualVal;
    public FB_selectAccountsController()
    {
        if(ApexPages.currentPage().getParameters().get('fieldType')=='Integer'||ApexPages.currentPage().getParameters().get('fieldType')=='Double'||ApexPages.currentPage().getParameters().get('fieldType')=='Currency')
        {
            if(ApexPages.currentPage().getParameters().get('value')=='')
            {
                actualVal = 0;
            }
            else
            {
                actualVal = Decimal.valueOf(ApexPages.currentPage().getParameters().get('value'));
            }
            soqlvar='select Id,Name,Account_Status__c,Type from Account where '+ApexPages.currentPage().getParameters().get('fieldName')+' '+ApexPages.currentPage().getParameters().get('operator')+' '+actualVal;
        }
        else
        {
            if(ApexPages.currentPage().getParameters().get('operator')=='like')
            {
                soqlvar='select Id,Name,Account_Status__c,Type from Account where '+ApexPages.currentPage().getParameters().get('fieldName')+' '+ApexPages.currentPage().getParameters().get('operator')+' '+ '\'%' +ApexPages.currentPage().getParameters().get('value') +'%\'';
            }
            else
            {
                soqlvar='select Id,Name,Account_Status__c,Type from Account where '+ApexPages.currentPage().getParameters().get('fieldName')+' '+ApexPages.currentPage().getParameters().get('operator')+' '+'\'' +ApexPages.currentPage().getParameters().get('value') +'\'';
            }
        }
    }
    String soqlvar;
    public List<Account> listOfAccounts{get;set;}
    
    public class Wrapper
    {
        public Boolean isChecked{get;set;}
        public Account instance{get;set;}
    }
    
    Set<String> selectedAccountRows = new Set<String>();
    public ApexPages.StandardSetController con {

        get {
            if(con == null) {
                //system.assertEquals(soqlvar, null);
                con = new ApexPages.StandardSetController(Database.getQueryLocator(soqlvar));
                // sets the number of records in each page set
                con.setPageSize(10);
            }
            return con;
        }
        set;
    }
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
        
            return con.getHasPrevious();
        }
        set;
    }
 
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
 
    // returns the first page of records
    public List<Account_Campaign_Member__c> listOfAccCampaignMembers; 
    public void first() {
        for(Wrapper loopVar :submissionList){
            if(loopVar.isChecked){
                selectedAccountRows.add(loopVar.instance.Id);
            }
            else{
                selectedAccountRows.remove(loopVar.instance.Id);
            }
        }
        con.first();
    }
 
    // returns the last page of records
    public void last() {
        for(Wrapper loopVar : submissionList){
            if(loopVar.isChecked){
                selectedAccountRows.add(loopVar.instance.Id);
            }
            else{
                selectedAccountRows.remove(loopVar.instance.Id);
            }
        }
        con.last();
    }
 
    // returns the previous page of records
    public void previous() {
        for(Wrapper loopVar : submissionList){
            if(loopVar.isChecked){
                selectedAccountRows.add(loopVar.instance.Id);
            }
            else{
                selectedAccountRows.remove(loopVar.instance.Id);
            }
        }
        con.previous();
    }
 
    // returns the next page of records
    public void next() {
        for(Wrapper loopVar : submissionList){
            if(loopVar.isChecked){
                selectedAccountRows.add(loopVar.instance.Id);
            }
            else{
                selectedAccountRows.remove(loopVar.instance.Id);
            }
        }
        con.next();
    }
     public  List<Wrapper> submissionList{get;set;}
    public List<Wrapper> getAccounts()
    {
        listOfAccounts = (List<Account>)con.getRecords();
        submissionList = new List<Wrapper>();
        
        for(Account a:listOfAccounts)
        {
            Wrapper wrapInstance = new Wrapper();
            wrapInstance.isChecked = false;
            wrapInstance.instance = a;
            submissionList.add(wrapInstance);
        }
        for(Wrapper w:submissionList)    
        {
            if(selectedAccountRows.contains(w.instance.id))
            {
                w.isChecked=true;
            }
            else
            {
                w.isChecked=false;
            }
        }
        System.debug(listOfAccounts );
        return submissionList;
    }
     
    public List<Account> submittedAcc;
    public Map<String,String> idStatusMap;
    public PageReference submit() 
    {
        listOfAccCampaignMembers = new List<Account_Campaign_Member__c>();
        idStatusMap = new Map<String,String>();
        PageReference pageRef = new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
        for(Wrapper w:submissionList)    
        {
            selectedAccountRows.remove(w.instance.id);
            if(w.isChecked)
            {
                selectedAccountRows.add(w.instance.id);
                idStatusMap.put(w.instance.id,w.instance.Account_Status__c);
            }
        }
        
        for(String acc : selectedAccountRows){
                Account_Campaign_Member__c AccCampaignMemberInstance = new Account_Campaign_Member__c();
                AccCampaignMemberInstance.Campaign__c = ApexPages.currentPage().getParameters().get('id');
                AccCampaignMemberInstance.Account__c = acc;
                AccCampaignMemberInstance.Account_Status1__c = idStatusMap.get(acc);
                listOfAccCampaignMembers.add(AccCampaignMemberInstance);
            }
         selectedAccountRows.clear();
        database.insert(listOfAccCampaignMembers);
        return pageRef;
    }
    

}