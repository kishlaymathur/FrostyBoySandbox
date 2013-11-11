trigger FB_RollUpQuantityAndCost on Spare_Parts_Used__c (before insert, before update) {
	Set<ID> sparePartIds=new Set<id>();
	for(Spare_Parts_Used__c instance:trigger.new){
		sparePartIds.add(instance.spare_part__c);
	}
	Map<Id,Machine__C> sparePartAndPurchaseMap=new Map<Id,Machine__c>([SELECT ID,(select id,Spare_Parts_Remaining__c,Machine__c,Unit_Price__c,Spare_Part_Used__c from purchases__r WHERE Spare_Parts_Remaining__c>0 order by purchase_Date__c asc limit 10) purchaseList FROM MACHINE__C WHERE ID IN:sparePartIds]);
	
	List<purchase__c> updatePurchaseList=new List<purchase__c>();
	Decimal totalCost=0;
	for(Spare_Parts_Used__c instance:trigger.new){
		totalCost=0;
		Decimal spareParts=instance.Quantity__c;
		List<Purchase__c> listPurchase=sparePartAndPurchaseMap.get(instance.Spare_Part__c).purchases__r;
		//system.debug(listPurchase);
		for(purchase__c p:listPurchase){
			//System.debug(p.Spare_Parts_Remaining__c);
			if(p.Spare_Parts_Remaining__c>=spareParts){
				System.debug(spareParts);
				p.Spare_Part_Used__c=p.Spare_Part_Used__c+spareParts;
				totalCost=totalCost+(spareParts*p.Unit_Price__c);
				spareParts=0;
				//System.debug(spareParts);
				updatePurchaseList.add(p);
				break;
			}
			else{
				spareParts=spareParts-p.Spare_Parts_Remaining__c;
				//System.debug(spareParts);
				p.Spare_Part_Used__c=p.Spare_Part_Used__c+p.Spare_Parts_Remaining__c;
				totalCost=totalCost+(p.Spare_Parts_Remaining__c*p.Unit_Price__c);
				updatePurchaseList.add(p);
			}
			//updatePurchaseList.add(p);
		}
		instance.Cost_Incurred__c=totalCost;
		
		
	}
	//system.debug(updatePurchaseList);
	if(updatePurchaseList.size()!=0)
	database.update(updatePurchaseList);
	
}