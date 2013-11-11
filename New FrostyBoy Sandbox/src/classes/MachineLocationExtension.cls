public class MachineLocationExtension{

    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name FROM Machine_Inventory__c]));
            }
            return setCon;
        }
        set;
    }
    
    public MachineLocationExtension(ApexPages.StandardSetController controller) {
    
         //setCon = Controller;
         //setCon.getRecord();
    }
    /*public PageReference locations()
    {
        List<Machine_Inventory__c> selectedLocations = (List<Machine_Inventory__c>) standardController.getSelected();       
        return null;   
    }*/
}