package problem10;

public class Ship {
    private String name;
    private String yearBuilt;

    // Constructor [cite: 95]
    public Ship(String name, String yearBuilt) {
        this.name = name;
        this.yearBuilt = yearBuilt;
    }

    // Accessors và Mutators [cite: 95]
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getYearBuilt() { return yearBuilt; }
    public void setYearBuilt(String yearBuilt) { this.yearBuilt = yearBuilt; }

    // Phương thức toString [cite: 96]
    @Override
    public String toString() {
        return "Name: " + name + ", Built year: " + yearBuilt;
    }
}