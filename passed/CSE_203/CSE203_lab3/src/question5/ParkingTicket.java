package question5;

public class ParkingTicket {

    private ParkedCar parkedCar;
    private PoliceOfficer officer;
    private ParkingMeter parkedMeter;
    private double fine;
    private double overtime;

    public ParkingTicket(PoliceOfficer officer, ParkedCar parkedCar, ParkingMeter parkedMeter) {
        this.officer = officer;
        this.parkedCar = parkedCar;
        this.parkedMeter = parkedMeter;
    }

    
    public double getFine(){
        if (officer.examineOverTime(parkedCar, parkedMeter)) {
            overtime = parkedCar.getParkingTime() - parkedMeter.getPurchasedTime();

            fine = 25.0;
            double hours = Math.ceil(overtime/60);
            if(hours > 1.0 ){
                fine += 10.0 * (hours-1);
            }

        }
        return fine;
    }


    @Override
    public String toString() {
        return "ParkingTicket \n" + parkedCar + "\n" + officer + "\n" + parkedMeter
                + "\nFine: " + getFine() ;
    }

    


}
