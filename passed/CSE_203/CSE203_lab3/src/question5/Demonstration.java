package question5;

public class Demonstration {
    public static void main(String[] args) {
        ParkedCar car1 = new ParkedCar("Black", "034519", "Toyota", "SUV", 60);
        ParkingMeter meter1 = new ParkingMeter(30);
        PoliceOfficer off1 = new PoliceOfficer("12023", "Tony");
        ParkingTicket ticket1 = new ParkingTicket(off1, car1,meter1);

        if(!off1.examineOverTime(car1, meter1)){
            System.out.println("This car don't be overtimed");
        }else{
        System.out.println(off1.issueTicket(car1, meter1));
        }
    }

}
