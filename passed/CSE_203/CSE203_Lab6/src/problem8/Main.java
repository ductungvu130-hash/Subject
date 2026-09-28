package problem8;

import java.time.LocalDate;

public class Main {
    public static void main(String[] args) {
        
        Restaurant res1 =new Restaurant("2011", "TP HCM", "KFC", "032141", 3.6, null);

        MenuItem burger = new MenuItem("M01", "Cheese Burger", 9, 50, "Classic beef burger with cheese");
        MenuItem fries = new MenuItem("M02", "French Fries", 2, 100, "Crispy golden fries");
        MenuItem soda = new MenuItem("M03", "Cola", 3, 200, "Refreshing cold drink");

        Customer cus1 = new Customer("eiudu", "1020", "Tony", "0921421");
        
        res1.addMenuItem(soda);
        res1.addMenuItem(fries);
        res1.addMenuItem(burger);

        Order myOrder = new Order(cus1, "100", LocalDate.now() );
        myOrder.addMenuItem(burger);
        myOrder.addMenuItem(burger); 
        myOrder.addMenuItem(fries);
        myOrder.addMenuItem(soda);
        myOrder.addMenuItem(soda);



        Discount dis1 = new PercentageDiscount(10);

        PaymentMethod pay1 = new CreditCard("5000122140");
        
        DeliveryMethod del1 = new BikeDelivery();
   

        OrderService ser1 = new OrderService(del1, dis1, myOrder.getId(), pay1, res1);
        ser1.process(myOrder);
    }
}
