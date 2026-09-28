package problem6;

public class Main {
    public static void main(String[] args) {
        IDrivable car = new Car();
        IDrivable truck = new Truck();

        car.drive();
        ((Car) car).passenger();

        truck.drive();
        ((Truck) truck).cargon();
    }
}
