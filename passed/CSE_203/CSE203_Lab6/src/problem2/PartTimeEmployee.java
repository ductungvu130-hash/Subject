package problem2;

public class PartTimeEmployee extends Employee {

    private double hourlyRate;
    private double hourWorked;

    public PartTimeEmployee(String name, double hourlyRate, double hourWorked) {
        super(name);
        this.hourlyRate = hourlyRate;
        this.hourWorked = hourWorked;
    }

    @Override
    public double calculatePay(){
        return this.hourlyRate * this.hourWorked;
    }

    @Override
    public String toString() {
        return "Employee Name : " + getName() + ", payment : "  + calculatePay();
    }

    
}
