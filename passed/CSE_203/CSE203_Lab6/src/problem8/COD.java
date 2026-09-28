package problem8;

public class COD implements PaymentMethod {
    @Override
    public void pay (double amount ){
        System.out.println("Paying " + amount + " by COD");
    }
}
