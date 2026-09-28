package problem10;

public class CruiseShip extends Ship {
    private int maxPassengers;

    // Constructor [cite: 100]
    public CruiseShip(String name, String yearBuilt, int maxPassengers) {
        super(name, yearBuilt);
        this.maxPassengers = maxPassengers;
    }

    // Accessors và Mutators [cite: 100]
    public int getMaxPassengers() { return maxPassengers; }
    public void setMaxPassengers(int maxPassengers) { this.maxPassengers = maxPassengers; }

    // Ghi đè phương thức toString (chỉ hiển thị tên và số hành khách) [cite: 101, 102]
    @Override
    public String toString() {
        return "Name of cruise ship: " + getName() + ", Maximum passengers: " + maxPassengers ;
    }
}
