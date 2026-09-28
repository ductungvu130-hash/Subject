package problem3;

class ProcessIPayPal implements IPayPalPayment {

    @Override
    public void processPayPal(double amount){
        System.out.println("Paying " + amount + " by using Paypal!");
    }

}
