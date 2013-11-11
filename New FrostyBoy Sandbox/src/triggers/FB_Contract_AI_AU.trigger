trigger FB_Contract_AI_AU on Contract (after insert,after update) {
    List<Machine_Inventory__c> listOfMcLocations = new List<Machine_Inventory__c>();
    List<Machine_Inventory__c> listOfMcLocations2 = new List<Machine_Inventory__c>();
    List<Id> listOfMcLocId = new List<Id>();
    if(Trigger.isInsert){
        for(Contract con : Trigger.new){
            if(con.Status == 'Activated'){
                Machine_Inventory__c newLoc = new Machine_Inventory__c();
                newLoc.Contract__c = con.Id;
                newLoc.Machine_Number__c = con.Machine_Serial_Number__c;
                newLoc.Distributor__c = con.AccountId;
                listOfMcLocations.add(newLoc);
            }
        }
    }
    else if (Trigger.isUpdate){
        Map<Id,Machine_Inventory__c> conIdMcLoc= new Map<Id,Machine_Inventory__c>();
        for(Contract con : Trigger.new){
            listOfMcLocId.add(con.id); 
        }
        System.debug('listOfmlId '+listOfMcLocId);
        for(Machine_Inventory__c mcinv : [select Name,Id,Contract__r.Id,Status__c from Machine_Inventory__c where Status__c='Allocated' AND Contract__r.id IN:listOfMcLocId]){
            conIdMcLoc.put(mcInv.Contract__r.Id,mcinv); 
        }
        for(Contract con : Trigger.new){
            if(Trigger.oldMap.get(con.Id).Status != 'Activated' && con.Status == 'Activated'){
                Machine_Inventory__c newLoc = new Machine_Inventory__c();
                newLoc.Contract__c = con.Id;
                newLoc.Machine_Number__c = con.Machine_Serial_Number__c;
                newLoc.Distributor__c = con.AccountId;
                listOfMcLocations.add(newLoc);
            }
            System.debug(!(conIdMcLoc.isEmpty())+' This is it');
            //if(conIdMcLoc.get(con.id)==null){
                if((Trigger.oldMap.get(con.Id).Status != 'Contract Terminated'||Trigger.oldMap.get(con.Id).Status != 'Contract Completed') && (con.Status == 'Contract Terminated'||con.Status == 'Contract Completed') && !(conIdMcLoc.isEmpty())){
                    Machine_Inventory__c newLoc1 = new Machine_Inventory__c();
                    newLoc1  = conIdMcLoc.get(con.Id);
                    newLoc1.Status__c = 'Contract Completed';
                    listOfMcLocations2.add(newLoc1);
                    System.debug(newLoc1+'atyl');
                    //conIdMcLoc.get(con.Id).Status__c = 'Contract Completed';
                    //listOfMcLocations2.add(conIdMcLoc.get(con.Id));
                }
            //           
        }
    }
    if(listOfMcLocations.size() > 0){
        try{
        DataBase.SaveResult[] results = database.insert(listOfMcLocations);
        }
        catch(Exception e){
           trigger.new[0].addError('The machine has already been allocated to an Active Contract. Please choose a different machine');
        }
    }
    if(listOfMcLocations2.size() > 0){
        database.update(listOfMcLocations2);
    }
        

}