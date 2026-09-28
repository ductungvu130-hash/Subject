package question5;

public class ParkedCar {
    private String make;
    private String model;
    private String color;
    private String license;
    private int parkingTime;

    public ParkedCar(String color, String license, String make, String model, int parkingTime) {
        this.color = color;
        this.license = license;
        this.make = make;
        this.model = model;
        this.parkingTime = parkingTime;
    }

    public String getMake() {
        return make;
    }

    public void setMake(String make) {
        this.make = make;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getLicense() {
        return license;
    }

    public void setLicense(String license) {
        this.license = license;
    }

    public int getParkingTime() {
        return parkingTime;
    }

    public void setParkingTime(int parkingTime) {
        this.parkingTime = parkingTime;
    }

    @Override
    public String toString() {
        return "Make: " + getMake() + ", Model: " + getModel() + ", Color: " + getColor()
                + ", License: " + getLicense() + ", Parking Time: " + getParkingTime() ;
    }


    


}
