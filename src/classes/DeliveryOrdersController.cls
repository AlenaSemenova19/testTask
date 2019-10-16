public class DeliveryOrdersController {
    public String orderId { get; set; }
    public List<Orders_for_Delivery__c> allOrders { get; set; }
    public Boolean displayPopup { get; set; }
    public Orders_for_Delivery__c newOrder { get; set; }
    public String searchString { get; set; }
    public List<SelectOption> allFieldsForOrders { get; set; }
    public String selectedField { get; set; }

    public DeliveryOrdersController() {
        loadOrders();
        addFieldsForSortingOrder();
    }

    public void loadOrders () {
        this.allOrders = [
                SELECT Name,
                        Delivery__c,
                        Total_weight_of_the_order__c,
                        Total_shipping_cost__c,
                        Delivery_date__c
                FROM Orders_for_Delivery__c];
    }

    public void addFieldsForSortingOrder() {
        allFieldsForOrders = new List<SelectOption>();
        allFieldsForOrders.add(new SelectOption('--None--', '--None--'));
        allFieldsForOrders.add(new SelectOption('Delivery__c', 'Delivery'));
        allFieldsForOrders.add(new SelectOption('Total_shipping_cost__c', 'Total shipping cost'));
        allFieldsForOrders.add(new SelectOption('Delivery_date__c', 'Delivery Date'));
    }

    public void saveNewOrder() {
        try {
            insert newOrder;
            displayPopup = false;
            loadOrders();
        } catch (System.Exception e) {
           ApexPages.addMessages(e);
        }
    }

    public void deleteOrder () {
        delete [SELECT Id FROM Orders_for_Delivery__c WHERE Id =:orderId];
        loadOrders();
    }

    public void openPopup() {
        displayPopup = true;
        newOrder = new Orders_for_Delivery__c();
    }

    public void closePopup() {
        displayPopup = false;
    }

    public void startSearch () {
        String str = 'SELECT Name, Delivery__c, Total_weight_of_the_order__c, Total_shipping_cost__c, Delivery_date__c ' +
                     'FROM Orders_for_Delivery__c WHERE Name LIKE \'%'+searchString+'%\'';
        allOrders = Database.query(str);
    }

    public void sortingByField () {
        String str = 'SELECT Name, Delivery__c, Total_weight_of_the_order__c, Total_shipping_cost__c, Delivery_date__c ' +
                     'FROM Orders_for_Delivery__c ORDER BY '+ selectedField + ' ASC';
        allOrders = Database.query(str);
    }
}