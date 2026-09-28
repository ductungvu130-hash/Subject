package problem4;

public class PaypalPayment implements PaymentStrategy {

    private String email;

    public PaypalPayment(String email) {
        this.email = email;
    }

    @Override
    public void pay(double amount) {
        System.out.printf("Paid $%.2f via PayPal (%s)%n", amount, email);
    }
}
