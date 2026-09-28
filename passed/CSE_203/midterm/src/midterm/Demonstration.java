package midterm;

public class Demonstration {
    public static void main(String[] args) {
        PetShopAdministration admin = new PetShopAdministration();
        

        Customer cus1 = new Customer("5005", "Tony", "067000");
        Customer cus2 = new Customer("1020", "Nguyen Van A", "342423"); //auto add 0

        admin.addCustomer(cus1);
        admin.addCustomer(cus2);

        Order order1 = new Order("1000", cus1);
        Order order2 = new Order("2000", cus2);
        

        Product prod1 = new Product("12312", "Chocopie", 50000, ProductCategory.OTHER);
        Product prod2 = new Product("33312", "Car", 10000, ProductCategory.TOY);
        
        OrderItem orderItem = new OrderItem(prod1, 5);
        
       

        admin.addOrder(order1);
        admin.addOrder(order2);

        admin.showAllCustomers();
        admin.showAllOrders();
    }

}
