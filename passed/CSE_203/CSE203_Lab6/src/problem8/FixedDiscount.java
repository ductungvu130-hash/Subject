package problem8;

public class FixedDiscount implements Discount {
    private double discountAmount;

    public FixedDiscount(double discountAmount) {
        this.discountAmount = discountAmount;
    }



    @Override
    public double execute(double amount){
        return Math.max(0, amount - discountAmount);
    }
}
