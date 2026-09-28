package problem6;

public class Truck implements ICargoCarrier,IDrivable{
    @Override
    public void cargon() {
        System.out.println("Truck is carrying heavy cargon.");
    }

    @Override
    public void drive() {
        System.out.println("Trucl is driving heavily.");
    }
}
