package problem3;

public class Main {
    public static void main(String[] args) {
        double bill = 500_000;

        ICreditCardPayment pay1 = new ProcessICreditCard();
        pay1.processCreditCard(bill);

        IPayPalPayment pay2 = new ProcessIPayPal();
        pay2.processPayPal(bill);

        ICryptoPayment pay3 = new ProcessCrypto();
        pay3.processCrypto(bill);
    }

}
