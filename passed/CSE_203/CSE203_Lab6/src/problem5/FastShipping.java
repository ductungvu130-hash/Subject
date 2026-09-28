package problem5;

public class FastShipping implements OrderFulfillment{
    @Override
    public void shippingService() {
        System.out.println("The package is delivering by the fast shipping service.");
    }
}
