package problem8;

public class MenuItem {
    private String id;
    private String name;
    private long price;
    private int unitsOnHand;
    private String description;

    public MenuItem(String id, String name, long price, int unitsOnHand, String description) {
        this.description = description;
        this.id = id;
        this.name = name;
        this.price = price;
        this.unitsOnHand = unitsOnHand;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public long getPrice() {
        return price;
    }

    public int getUnitsOnHand() {
        return unitsOnHand;
    }

    public String getDescription() {
        return description;
    }




}
