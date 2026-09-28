package problem3;

interface ICreditCardPayment {
    void processCreditCard(double amount);
}

interface IPayPalPayment {
    void processPayPal(double amount);
}

interface ICryptoPayment {
    void processCrypto(double amount);
}
