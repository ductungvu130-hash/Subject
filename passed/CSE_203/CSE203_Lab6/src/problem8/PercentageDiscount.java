package problem8;

public class PercentageDiscount implements Discount {
    private double discountPercentage;

    public PercentageDiscount(double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    @Override
    public double execute(double amount){
        return amount * (1 - (this.discountPercentage)/100) ;
    }

}
