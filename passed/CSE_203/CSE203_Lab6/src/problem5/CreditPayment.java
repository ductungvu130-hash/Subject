package problem5;

public class CreditPayment implements PaymentProcess{
    private String cardNumber;

    public CreditPayment(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    @Override
    public void pay() {
        System.out.println("The package is payed by the Credit Payment which the card number is "+this.cardNumber);
    }
}
