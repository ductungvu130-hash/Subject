package problem8;

public class RocketDelivery implements DeliveryMethod {
    @Override
    public void process(String orderId){
        System.out.println("Delivery by Rocket. Order ID is "+ orderId);
    }
}
