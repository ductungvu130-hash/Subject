package problem4;

public class ShoppingItem {

    private String description;
    private double cost;

    public ShoppingItem(String description, double cost) {
        this.description = description;
        this.cost = cost;
    }

    public String getDescription() {
        return description;
    }

    public double getCost() {
        return cost;
    }
}
