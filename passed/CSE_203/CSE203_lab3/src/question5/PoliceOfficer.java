package question5;

public class PoliceOfficer {
    private String name;
    private String badgeNumber;

    public PoliceOfficer(String badgeNumber, String name) {
        this.badgeNumber = badgeNumber;
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBadgeNumber() {
        return badgeNumber;
    }

    public void setBadgeNumber(String badgeNumber) {
        this.badgeNumber = badgeNumber;
    }

    public boolean examineOverTime(ParkedCar pc , ParkingMeter pm){
        if(pc.getParkingTime() > pm.getPurchasedTime()){
            return true;
        }else
            return false;

    }

    public ParkingTicket issueTicket(ParkedCar car, ParkingMeter meter) {
        if (examineOverTime(car, meter)) {
            return new ParkingTicket(this, car,meter);
        }
        return null;
    }

    @Override
    public String toString() {
        return "Police Officer Name: " + getName() + ", Badge Number: " + getBadgeNumber() ;
    }
    
    
}
