package problem1_2_3;

import java.time.LocalDate;

public class ProductionWorker extends Employee{

    private int shift;
    private double payRate;
    
    
    public ProductionWorker(String name , String number, LocalDate hireDate, int shift, double payRate) {
        super(name, number, hireDate);
        this.shift = shift;
        this.payRate = payRate;
    }



    public int getShift() {
        return shift;
    }

    public void setShift(int shift) {
        this.shift = shift;
    }

    public double getPayRate() {
        return payRate;
    }

    public void setPayRate(double payRate) {
        this.payRate = payRate;
    }

    


}
