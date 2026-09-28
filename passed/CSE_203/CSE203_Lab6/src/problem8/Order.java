package problem8;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

public class Order {
    private String id;
    private LocalDate orderDate;
    private Customer c;
    private Map<MenuItem, Integer> items;

    public Order(Customer c, String id, LocalDate orderDate) {
        this.c = c;
        this.id = id;
        this.items = new HashMap<>();
        this.orderDate = orderDate;
    }

     public void addMenuItem(MenuItem m){
        items.put(m, items.getOrDefault(m, 0)+1);
    }

    public void removeMenuItem(MenuItem m ){
        items.remove(m);
    }


    public String getId() {
        return id;
    }

    public LocalDate getOrderDate() {
        return orderDate;
    }

    public Customer getC() {
        return c;
    }

    public Map<MenuItem, Integer> getItems() {
        return items;
    }

    public double getSubTotal(){
        double subTotal =0.0;
        for (Map.Entry<MenuItem, Integer> entry : items.entrySet()) {
        MenuItem item = entry.getKey();   
        int quantity = entry.getValue();  
        
        subTotal += (item.getPrice() * quantity);
    }
       return subTotal; 
    }

}
