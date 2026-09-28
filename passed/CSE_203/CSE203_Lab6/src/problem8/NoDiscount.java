package problem8;

public class NoDiscount implements Discount {
    @Override
    public double execute(double amount){
        return amount ;
    }
}
