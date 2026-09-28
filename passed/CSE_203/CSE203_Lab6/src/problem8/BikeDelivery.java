package problem8;

public class BikeDelivery implements DeliveryMethod {
    @Override
    public void process(String orderId){
        System.out.println("Delivery by bike. Order ID is "+ orderId);
    }
}
