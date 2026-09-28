package section1;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private List<AProduct> products;
    private Customer customer;
    private LocalDate orderedDate;

    public Order(Customer customer, LocalDate orderedDate) {
        this.customer = customer;
        this.orderedDate = orderedDate;
        this.products = new ArrayList<>();
    }
    

    public void addProduct(String productType, String brand, String license, Double price, String lotNumber, String manufacturedCountry){
        if(productType.equals("medicine")){
            products.add(new Medicine(brand, license, price, lotNumber));    
        }else 
            if(productType.equals("toy")){
            products.add( new Toy(brand, license, price, manufacturedCountry));    
        }
        
    }    

    public double getTotalPrice(){
        double total = 0 ;

        for(AProduct pro : products){
            total += pro.caculateCost();
        }
        return total;
    }


    public void generateReceipt(){
        StringBuilder sb = new StringBuilder();

        sb.append(customer.getName()).append(" ( ").append(customer.getPhoneNumber()).append(" ) ").append("\n");
        sb.append("Total product: ").append(products.size()).append("\n");
        sb.append("Ordered day: ").append(LocalDate.now()).append("\n");
        sb.append("Total price: ").append(getTotalPrice());
        System.out.println(sb.toString());
    }
}
