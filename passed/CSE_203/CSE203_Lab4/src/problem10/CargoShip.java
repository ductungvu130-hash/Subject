package problem10;

public class CargoShip extends Ship {
    private int cargoCapacity;

    // Constructor [cite: 106]
    public CargoShip(String name, String yearBuilt, int cargoCapacity) {
        super(name, yearBuilt);
        this.cargoCapacity = cargoCapacity;
    }

    // Accessors và Mutators [cite: 106]
    public int getCargoCapacity() { return cargoCapacity; }
    public void setCargoCapacity(int cargoCapacity) { this.cargoCapacity = cargoCapacity; }

    // Ghi đè phương thức toString (chỉ hiển thị tên và trọng tải) [cite: 107, 108]
    @Override
    public String toString() {
        return "Name of carga ship: " + getName() + ", Capicity: " + cargoCapacity + " ton";
    }
}
