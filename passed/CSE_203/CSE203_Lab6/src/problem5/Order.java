package problem5;

public class Order {
    private String id;
    private double totalBill;


    public Order(String id, double totalBill) {
        this.id = id;
        this.totalBill = totalBill;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getTotalBill() {
        return totalBill;
    }

    public void setTotalBill(double totalBill) {
        this.totalBill = totalBill;
    }
}
