package midterm;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private String id;
    private Customer customer;
    private OrderItem oder;
    private List<OrderItem> orderItemList;
    private OrderStatus orderStatus;
    private LocalDate issuedDate;
    public Object setOrderStatus;

    
    public Order(String id, Customer customer) {
        this.id = id;
        this.customer = customer;
        issuedDate = LocalDate.now();
        this.orderItemList = new ArrayList<>();
        
    } 


    public String getId() {
        return id;
    }


    public void setId(String id) {
        this.id = id;
    }


    public Customer getCustomer() {
        return customer;
    }


    public void setCustomer(Customer customer) {
        this.customer = customer;
    }


    public List<OrderItem> getOderItemList() {
        return oderItemList;
    }


    public void setOderItemList(List<OrderItem> oderItemList) {
        this.oderItemList = oderItemList;
    }


    public OrderStatus getOrderStatus() {
        return orderStatus;
    }


    public void setOrderStatus(OrderStatus orderStatus) {
        this.orderStatus = orderStatus;
    }


    public LocalDate getIssuedDate() {
        return issuedDate;
    }


    public void setIssuedDate(LocalDate issuedDate) {
        this.issuedDate = issuedDate;
    }


    


    @Override
    public String toString() {
        return "Id: " + getId() + ", Customer: " + getCustomer() + ", Oder Item List: "
                + getOderItemList() + ", Order Status: " + getOrderStatus() + ", Issued Date: " + getIssuedDate();
    }

    public void addOderItem(Product product){
        oderItemList.add(new OrderItem(product,1));
    } 

    public void removeOderItem(Product product){
        oderItemList.remove(new OrderItem(product,1));
    } 

    public long getTotalOderPrice(){
        long totalCost = 0;
        for( OrderItem eItems: oderItemList ){
            totalCost += eItems.getProduct().getPrice();
        }
        return totalCost;
    }
}
