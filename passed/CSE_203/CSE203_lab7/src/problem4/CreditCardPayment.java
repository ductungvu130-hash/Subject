package problem4;

public class CreditCardPayment implements PaymentStrategy {

    private String cardNumber;

    public CreditCardPayment(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    @Override
    public void pay(double amount) {
        System.out.printf("Paid $%.2f using Credit Card (****%s)%n",
                amount, cardNumber.substring(cardNumber.length() - 4));
    }
}
