package problem5;

public class Main {
    public static void main(String[] args) {
        Order order1 = new Order("O01",150);

        OrderValidation priceValid = new BillValidation();
        if (priceValid.isValid(order1)){
            PaymentProcess payment = new CreditPayment("231244");
            OrderFulfillment ship = new FastShipping();

            System.out.println("The Order's ID " +order1.getId());
            payment.pay();
            ship.shippingService();
        }else {
            System.out.println("THe price must be positive.");
        }
    }
}
