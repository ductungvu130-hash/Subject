package problem7_8;

public class Demo {
    public static void main(String[] args) {
       
        PreferredCustomer myCustomer = new PreferredCustomer(
            "John Doe", 
            "123 University St, Binh Duong", 
            "090-111-2222", 
            "CUST-101-A", 
            true, 
            0.0
        );

        System.out.println("--- Initial Customer Information ---");
        displayCustomerInfo(myCustomer);

        
        System.out.println("\n--- Updating purchases to $600 ---");
        myCustomer.setPurchases(600.0);
        displayCustomerInfo(myCustomer);

       
        System.out.println("\n--- Updating purchases to $2,500 ---");
        myCustomer.setPurchases(2500.0);
        displayCustomerInfo(myCustomer);
    }

    
    public static void displayCustomerInfo(PreferredCustomer customer) {
        System.out.println("Name: " + customer.getName());
        System.out.println("Address: " + customer.getAddress());
        System.out.println("Telephone: " + customer.getTelephone());
        System.out.println("Customer Number: " + customer.getCustomerNumber());
        System.out.println("On Mailing List: " + (customer.isMailingList() ? "Yes" : "No"));
        System.out.println("Cumulative Purchases: $" + customer.getPurchases());
        System.out.println("Discount Level: " + (customer.getDiscountLevel() * 100) + "%");
    }
}