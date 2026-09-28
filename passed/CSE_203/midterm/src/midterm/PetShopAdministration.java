package midterm;

import java.util.ArrayList;
import java.util.List;

public class PetShopAdministration {
    private List<Customer> customers;
    private List<Order> oders;

    public PetShopAdministration() {
        this.customers = new ArrayList<>();
        this.oders = new ArrayList<>();
    }

    public void addCustomer(Customer cus){
        customers.add(cus);
    }

    public void addOrder(Order odr){
        oders.add(odr);
    }

    public void showAllCustomers(){
        System.out.println("All customers: ");
        for(Customer c : customers){
            System.out.println(c.toString());
        }
    }
    public void showAllOrders(){
        System.out.println("All oders: ");
        for(Order c : oders){
            System.out.println(c.toString());
        }
    }
}
