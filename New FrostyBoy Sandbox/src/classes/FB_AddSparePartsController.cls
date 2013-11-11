public class FB_AddSparePartsController {
    private final Case caseRecord;
    public Boolean showSection {get;set;}
    public Boolean showAddButton {get;set;}
    public Spare_Parts_used__c newSparePart{get;set;}
    public List<Spare_Parts_used__c> sparePartsList=new List<Spare_Parts_used__c>();
    ApexPages.StandardController sc;
    public Boolean isError {get;set;}
    public Machine__C machine;
   
    public FB_AddSparePartsController(ApexPages.StandardController controller) {
        sc=controller;
        isError=true;
        this.caseRecord = (Case)controller.getRecord();
        showSection = false;
        showAddButton = true;
    }
    public PageReference addSparePart(){
        showSection = true;
        showAddButton = false;
        newSparePart=new Spare_Parts_used__c();
        return null;
    }
    public Task newtask;
    public Boolean flag;
    
    public void addTask()
    {
        if(flag)
        database.insert(newTask);
    }
    public PageReference save(){
                
        newSparePart.case__c=caseRecord.id;
        
        flag=false;
        machine=[select id,name,spare_Parts_remaining__c,Minimum_Stock__c from Machine__c where id=:newSparePart.Spare_Part__c];
        if(machine.Spare_Parts_Remaining__c>=newSparePart.Quantity__c){
        isError=false;
        showSection = false;
        showAddButton = true;
         insert newSparePart;
         if((machine.Spare_Parts_Remaining__c-newSparePart.Quantity__c)<=machine.Minimum_Stock__c)
         {
             flag=true;
             ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Stock for '+machine.Name+' has gone below minimum.Please buy more stock.');
             ApexPages.addMessage(infoMsg);
             newtask = new Task();
             newTask.Subject = 'Call';
             newTask.Description= 'Stock for '+machine.name+' has gone below minimum stock required.';
             newTask.whatId = machine.Id;
             newTask.OwnerId= [select Name,User_Id__c from Designations__c where Name='Operations Manager' limit 1].User_Id__c;
             newTask.Status = 'Not Started';
             newTask.Priority = 'High';
             addTask();
        }
        // newSparePart=new Spare_Parts_used__c();
         }
        else{
        isError=true;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have sufficient spare parts in your inventory');
        ApexPages.addMessage(myMsg);
            
        }
        
        return null;        
    }
    public List<Spare_Parts_used__c> getTableValues()
    {
        
        sparePartsList=[select Id,Name,Quantity__c,Spare_Part__c,Spare_Part__r.item__c,Spare_Part__r.Id,Spare_Part__r.Name,Case__C,CreatedDate from Spare_Parts_used__c where Case__C=:caseRecord.Id order by CreatedDate desc];
        
        return sparePartsList;
        
    }   
    public String pageURL {set;}
    public String getPageURL() {
        
    PageReference pageRef = sc.view();
    return pageRef.getUrl();    
}
  
}