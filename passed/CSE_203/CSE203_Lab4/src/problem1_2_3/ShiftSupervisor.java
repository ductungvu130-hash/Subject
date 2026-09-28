package problem1_2_3;

import java.time.LocalDate;

public class ShiftSupervisor extends Employee {
    private double annualSalary;
    private double annualBonus;


    public ShiftSupervisor(String name, String number, LocalDate hireDate, double annualSalary, double annualBonus) {
        super(name, number, hireDate);
        this.annualSalary = annualSalary;
        this.annualBonus = annualBonus;
    }


    public double getAnnualSalary() {
        return annualSalary;
    }


    public void setAnnualSalary(double annualSalary) {
        this.annualSalary = annualSalary;
    }


    public double getAnnualBonus() {
        return annualBonus;
    }


    public void setAnnualBonus(double annualBonus) {
        this.annualBonus = annualBonus;
    }


    
    

}
