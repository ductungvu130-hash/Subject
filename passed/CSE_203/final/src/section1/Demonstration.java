package section1;

import java.time.LocalDate;

public class Demonstration {
    public static void main(String[] args) {
        
        OrderingService oService = new OrderingService();
        Customer customer_1 = new Customer("Customer ID 1", "Customer name 1", "0123xxx789");
        Customer customer_2 = new Customer("Customer ID 2", "Customer name 2", "0123---zzz");

        Order order_1 = new Order(customer_1, LocalDate.now());
        Order order_2 = new Order(customer_2, LocalDate.now());

        order_1.addProduct("medicine", "Med Brand 1.1", "Med License 1", 20.5, "Lot 1", null);
        order_1.addProduct("medicine", "Med Brand 1.2", "Med License 1", 35.5, "Lot 1", null);
        order_1.addProduct("toy", "Toy Brand 1", "Toy license 1", 21.1, null, "Vietnam");
        order_2.addProduct("medicine", "Med Brand 2.1", "Med License 2", 69.9, "Lot 2", null);
        order_2.addProduct("toy", "Toy Brand 2", "Toy license 2", 22.5, null, "Laos");   


        oService.addCustomer(customer_1);
        oService.addCustomer(customer_2);

        oService.addOrder(order_2);
        oService.addOrder(order_1);

        oService.printAllOrder();
    }
}
