package problem7_8;

public class PreferredCustomer extends Customer {
    private double purchases;
    private double discountLevel;

    public PreferredCustomer(String name, String address, String telephone, String customerNumber, boolean mailingList, double purchases) {
        super(name, address, telephone, customerNumber, mailingList);
        setPurchases(purchases);
    }

    public void setPurchases(double purchases) {
        this.purchases = purchases;
        // Logic chiết khấu [cite: 71, 72, 73, 74]
        if (purchases >= 2000) discountLevel = 0.10;
        else if (purchases >= 1500) discountLevel = 0.07;
        else if (purchases >= 1000) discountLevel = 0.06;
        else if (purchases >= 500) discountLevel = 0.05;
        else discountLevel = 0.0;
    }

    public double getPurchases() { return purchases; }
    public double getDiscountLevel() { return discountLevel; }
}
