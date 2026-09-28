package problem4;

public class CashPayment implements PaymentStrategy {

    @Override
    public void pay(double amount) {
        System.out.printf("Paid $%.2f in Cash%n", amount);
    }
}
