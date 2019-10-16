trigger CheckingTotalWeightTrigger on Orders_for_Delivery__c (before insert, before update) {
	Set<Id> deliveryIDs = new Set<Id>();

    for(Orders_for_Delivery__c ord : Trigger.new) {
        deliveryIDs.add(ord.Delivery__c);
    }

    Map<Id, Delivery__c> ordersForDelivery = new Map<Id, Delivery__c>(
        [SELECT Id, Max_weight__c, Number_of_delivery_days__c FROM Delivery__c WHERE Id IN :deliveryIDs]
    );
    
    for(Orders_for_Delivery__c ord : Trigger.new) {
        if(ord.Total_weight_of_the_order__c > ordersForDelivery.get(ord.Delivery__c).Max_weight__c) {
            Decimal result = ord.Total_weight_of_the_order__c / ordersForDelivery.get(ord.Delivery__c).Max_weight__c
            * ordersForDelivery.get(ord.Delivery__c).Number_of_delivery_days__c;

            Date deliveryDate = ord.Delivery_date__c;
            ord.Delivery_date__c = deliveryDate.addDays(Integer.valueOf(result));
        }
    }
}