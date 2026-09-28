package problem5;

public class COD implements PaymentProcess{
    @Override
    public void pay() {
        System.out.println("The package is payed by The COD Method.");
    }
}
