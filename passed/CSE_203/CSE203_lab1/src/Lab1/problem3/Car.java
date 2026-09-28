package problem3;

public class Car {
    private String make;
    private String model;
    private String period;
    private int milage;


    public Car(String make, String model, String period, int milage) {
        this.make =make;
        this.model = model;
        this.period = period;
        this.milage = milage;
        
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
    public String getPeriod() {
        return period;
    }
    public void setPeriod(String period) {
        this.period = period;
    }
    public int getMilage() {
        return milage;
    }
    public void setMilage(int milage) {
        this.milage = milage;
    }
    @Override
    public String toString() {
        return "Make of car: "+ getMake()+ ", Car Model: " + getModel() + ", Period: " + getPeriod() + ", Milage: " + getMilage() ;
    }


    

    
    

    
}
