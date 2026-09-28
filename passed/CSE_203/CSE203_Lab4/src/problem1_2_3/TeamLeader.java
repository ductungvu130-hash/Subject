package problem1_2_3;

import java.time.LocalDate;

public class TeamLeader extends ProductionWorker{

    private double moneyBonus;
    private double trainingHours;
    private double attendedHours;

    
    public TeamLeader(String name, String number, LocalDate hireDate, int shift, double payRate, double moneyBonus,
            double trainingHours, double attendedHours) {
        super(name, number, hireDate, shift, payRate);
        this.moneyBonus = moneyBonus;
        this.trainingHours = trainingHours;
        this.attendedHours = attendedHours;
    }


    public double getMoneyBonus() {
        return moneyBonus;
    }


    public void setMoneyBonus(double moneyBonus) {
        this.moneyBonus = moneyBonus;
    }


    public double getTrainingHours() {
        return trainingHours;
    }


    public void setTrainingHours(double trainingHours) {
        this.trainingHours = trainingHours;
    }


    public double getAttendedHours() {
        return attendedHours;
    }


    public void setAttendedHours(double attendedHours) {
        this.attendedHours = attendedHours;
    }


    @Override
    public String toString() {
        return "Name: " + getName() +
                "\nNumber: " + getNumber() +
                "\nHire Date: " + getHireDate()+
                "\nShift: " + getShift() + 
                "\nPay Rate: " + getPayRate() + 
                "\nMoney Bonus: "+ getMoneyBonus() + 
                "\nTrainingHours: " + getTrainingHours() +  ", Attended Hours: " + getAttendedHours() ;
    }

    

}
