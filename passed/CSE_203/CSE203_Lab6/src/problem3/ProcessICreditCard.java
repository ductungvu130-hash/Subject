package problem3;

class ProcessICreditCard implements ICreditCardPayment  {
    @Override
    public void processCreditCard(double amount){
        System.out.println("Paying " + amount + " by using credit card!");
    }

}
