trigger FB_GenerateMonthlyPaymentOfInactiveMachineInventory on Machine_Inventory__c (after update) {
      List<String> machineLocationIds=new List<String>();
      for(Machine_Inventory__c machineLocation:trigger.new){
            //System.debug(MachineLocation);
            if(machineLocation.Status__c=='Ready' && Trigger.oldMap.get(machineLocation.id).status__c!='Ready')
            machineLocationIds.add(machineLocation.id);
        }
        if(!machineLocationIds.isEmpty())
        FB_ClassGenerateMonthlyPayments.ExecuteGenerateMonthlyPayment(machineLocationIds,'Ready');
        //system.debug(machineLocationIds.size());
        
        public Map<Id,Machine_Inventory__c> mapOfmachineIdAndStatus = new Map<Id,Machine_Inventory__c>();
        //public Map<Id,String> mapOfmachineIdAndCustomer = new Map<Id,String>();
        //public Map<Id,String> mapOfmachineIdAndDistributor = new Map<Id,String>();
        for(Machine_Inventory__c machineLocation:trigger.new)
        {
            if(trigger.IsUpdate && Trigger.oldMap.get(machineLocation.id).status__c!=machineLocation.status__c)
            {
                mapOfmachineIdAndStatus.put(machineLocation.Machine_Number__c,machineLocation);
                //if(machineLocation.Customer__c!=null)
                //System.debug(machineLocation.Customer__r.Name+' New Checker 2');
                //mapOfmachineIdAndCustomer.put(machineLocation.Machine_Number__c,machineLocation.Customer__r.Name);
                //if(machineLocation.Distributor__c!=null)
                //mapOfmachineIdAndDistributor.put(machineLocation.Machine_Number__c,machineLocation.Distributor__r.Name);
            }
        }
        if(!mapOfmachineIdAndStatus.isEmpty())
        {
            for(Machine__c instanceOfMachine:[select Id from Machine__c where Id IN:mapOfmachineIdAndStatus.keyset()])
            {
                System.debug((mapOfmachineIdAndStatus.get(instanceOfMachine.Id)).Status__c+' -- New Checker On Machine Location Status');
                System.debug((mapOfmachineIdAndStatus.get(instanceOfMachine.Id)).Customer__c+' -- New Checker 2 On Machine Location Status');
                System.debug((mapOfmachineIdAndStatus.get(instanceOfMachine.Id)).DistributorId__c+' -- New Checker 2 On Machine Location Status');
                if((mapOfmachineIdAndStatus.get(instanceOfMachine.Id)).Status__c=='Allocated')
                {
                    instanceOfMachine.Current_Machine_Location__c = (mapOfmachineIdAndStatus.get(instanceOfMachine.Id)).Customer__c;
                }
                else
                {
                    System.Debug('in in in');
                    instanceOfMachine.Current_Machine_Location__c = (mapOfmachineIdAndStatus.get(instanceOfMachine.Id)).DistributorId__c;
                }
                update instanceOfMachine;
            }
        }
        
    
}