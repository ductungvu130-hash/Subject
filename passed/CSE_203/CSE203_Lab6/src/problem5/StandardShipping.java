package problem5;

public class StandardShipping implements OrderFulfillment{
    @Override
    public void shippingService() {
        System.out.println("The package is delivering by the standard shipping service.");
    }
}
