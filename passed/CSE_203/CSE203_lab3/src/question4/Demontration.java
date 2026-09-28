package question4;

public class Demontration {
    public static void main(String[] args) {
        Fuelgauge fuel = new Fuelgauge();
        Odometer odometer = new Odometer(0);

        
        System.out.println("Fill the tank");
        for (int i = 0; i < 15; i++) {
            fuel.puttingFuel();
        }
        
        System.out.println("Starting the journey");
        
        while (fuel.getAmountFuel() > 0) {
            odometer.addMile(fuel);
           
            System.out.println("Mileage: " + odometer.getCurrentMilage() + " | Fuel: " + fuel.getAmountFuel() + " Gallons");
        }

        
        System.out.println("Out of gas! Final Mileage: " + odometer.getCurrentMilage());
    }
}