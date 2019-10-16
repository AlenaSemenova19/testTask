@IsTest
public class DeliveryOrdersTest {

    @IsTest static void loadOrdersTest1() {
        Test.startTest();

        DeliveryOrdersController controller =new DeliveryOrdersController();
        controller.loadOrders();

        Test.stopTest();

        System.assert(controller.allOrders.isEmpty());
    }

    @IsTest static void loadOrdersTest2() {

        Delivery__c testDelivery = new Delivery__c(Name = 'TestDelivery');
        insert testDelivery;

        Orders_for_Delivery__c testOrder = new Orders_for_Delivery__c (
                Name = 'TestOrder',
                Delivery__c = testDelivery.Id
        );
        insert testOrder;

        Test.startTest();

        DeliveryOrdersController controller =new DeliveryOrdersController();
        controller.loadOrders();

        Test.stopTest();

        System.assert(controller.allOrders.size() == 1);
    }

    @IsTest static void saveNewOrderTest() {
        Delivery__c testDelivery = new Delivery__c(Name = 'TestDelivery');
        insert testDelivery;

        Test.startTest();

        DeliveryOrdersController controller = new DeliveryOrdersController();
        controller.newOrder = new Orders_for_Delivery__c (
                Name = 'TestOrder',
                Delivery__c = testDelivery.Id
        );
        controller.saveNewOrder();

        Test.stopTest();

        List<Orders_for_Delivery__c> allOrders = [
                SELECT Id, Name, Delivery__c
                FROM Orders_for_Delivery__c
                WHERE Name ='TestOrder'
                AND Delivery__c =:testDelivery.Id
        ];
        System.assert(!allOrders.isEmpty());
        System.assert(allOrders.size() == 1);
    }

    @IsTest static void deleteOrderTest() {
        Delivery__c testDelivery = new Delivery__c(Name = 'TestDelivery');
        insert testDelivery;

        Orders_for_Delivery__c createOrder = new Orders_for_Delivery__c (
                Name = 'TestOrder',
                Delivery__c = testDelivery.Id
        );
        insert createOrder;

        Test.startTest();

        DeliveryOrdersController controller = new DeliveryOrdersController();
        controller.orderId = createOrder.Id;
        controller.deleteOrder();

        List<Orders_for_Delivery__c> allOrders = [
                SELECT Id
                FROM Orders_for_Delivery__c
                WHERE Id =:createOrder.Id
        ];

        Test.stopTest();

        System.assert(allOrders.isEmpty());
    }

    @IsTest static void startSearchTest() {
        Delivery__c testDelivery = new Delivery__c(Name = 'TestDelivery');
        insert testDelivery;

        List<Orders_for_Delivery__c> orderList = new List<Orders_for_Delivery__c>();

        for(Integer i=0; i<10; i++){
            Orders_for_Delivery__c order = new Orders_for_Delivery__c(
                    Name='Test'+i,
                    Delivery__c = testDelivery.Id
            );
            orderList.add(order);
        }
        insert orderList;

        Test.startTest();

        DeliveryOrdersController controller = new DeliveryOrdersController();
        controller.searchString = 'Test';
        controller.startSearch();

        List<Orders_for_Delivery__c> allOrders = [
                SELECT Name, Delivery__c
                FROM Orders_for_Delivery__c
                WHERE Name LIKE '%Test%'
        ];
        Test.stopTest();

        System.assert(!allOrders.isEmpty());
    }

    @IsTest static void sortingByFieldTest() {
        Delivery__c testDelivery = new Delivery__c(Name = 'TestDelivery');
        insert testDelivery;

        List<Orders_for_Delivery__c> orderList = new List<Orders_for_Delivery__c>();

        for (Integer i=0; i<10; i++) {
            Orders_for_Delivery__c order = new Orders_for_Delivery__c(
                    Name='Test'+i,
                    Delivery__c = testDelivery.Id,
                    Total_weight_of_the_order__c = i
            );
            orderList.add(order);
        }
        insert orderList;

        Test.startTest();

        DeliveryOrdersController controller = new DeliveryOrdersController();

        controller.selectedField = 'Total_weight_of_the_order__c';
        controller.sortingByField();

        List<Orders_for_Delivery__c> allOrders = [
                SELECT Name, Delivery__c, Total_weight_of_the_order__c
                FROM Orders_for_Delivery__c
                ORDER BY Total_weight_of_the_order__c ASC
        ];

        Test.stopTest();

        System.assert(!allOrders.isEmpty());
    }
}