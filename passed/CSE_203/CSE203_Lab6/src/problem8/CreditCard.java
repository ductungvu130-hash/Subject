package problem8;

public class CreditCard implements PaymentMethod {

    private String cardNumber;

    public CreditCard(String cardNumber) {
        this.cardNumber = cardNumber;
    }



    @Override
    public void pay (double amount ){
        System.out.printf("Paying %.2f by card. Card number is %s \n", amount, this.cardNumber);
    }
}
