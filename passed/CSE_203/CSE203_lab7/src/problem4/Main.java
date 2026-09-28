package problem4;

public class Main {

    public static void main(String[] args) {
        ShoppingCart cart = new ShoppingCart();
        cart.addItem(new ShoppingItem("Laptop", 80.0));
        cart.addItem(new ShoppingItem("Mouse", 20.0));

        cart.setPaymentStrategy(new CreditCardPayment("1234567890123456"));
        cart.checkout();

        System.out.println();

        cart.setPaymentStrategy(new PaypalPayment("user@example.com"));
        cart.checkout();

        System.out.println();

        cart.setPaymentStrategy(new CashPayment());
        cart.checkout();
    }
}
