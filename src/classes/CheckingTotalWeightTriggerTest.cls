@IsTest
public class CheckingTotalWeightTriggerTest {
    @IsTest static void addDaysForOrders() {
        Delivery__c delivery = new Delivery__c(
                Name='Test delivery',
                Max_weight__c=30,
                Number_of_delivery_days__c=3
        );
        insert delivery;

        Orders_for_Delivery__c order = new Orders_for_Delivery__c(
                Name='Test order',
                Total_weight_of_the_order__c = 40,
                Delivery_date__c=Date.today(),
                Delivery__c =delivery.Id
        );
        insert order;
    }
}