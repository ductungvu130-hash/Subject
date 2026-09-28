package section1;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class OrderingService {
    private List<Customer> cusList;
    private List<Order> ordList;


    public OrderingService() {
        this.cusList = new ArrayList<>();
        this.ordList = new ArrayList<>();
    }

    public void addCustomer(Customer cus){
        cusList.add(cus);
    }

    public void addOrder(Order ord){
        ordList.add(ord);
    }

    public void orderProducts(Customer cus, List<AProduct> products){
        Order newOrder = new Order(cus, LocalDate.now());
        
        for(AProduct p : products) {
            if(p instanceof Medicine) {
                newOrder.addProduct("medicine", p.getBrand(), p.license, p.getPrice(), "Lot X", null);
            } else if (p instanceof Toy) {
                newOrder.addProduct("toy", p.getBrand(), p.license, p.getPrice(), null, "Country Y");
            }
        }
        ordList.add(newOrder);
        newOrder.generateReceipt();
    }


    public void printAllOrder(){
        for( Order ord : ordList){
            ord.generateReceipt();
        }
    }
}
