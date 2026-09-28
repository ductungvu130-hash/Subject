package problem2;

public class FullTimeEmployee extends Employee {

    private double monthlyPay;

    public FullTimeEmployee(String name, double monthlyPay) {
        super(name);
        this.monthlyPay = monthlyPay;
    }

    @Override
    public double calculatePay(){
        return this.monthlyPay;
    }

    @Override
    public String toString() {
        return "Employee Name: " + getName() + ", payment: " + calculatePay() ;
    }

    

}
