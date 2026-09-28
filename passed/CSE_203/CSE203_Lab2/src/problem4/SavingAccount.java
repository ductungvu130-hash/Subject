package problem4;

public class SavingAccount {
    private double annualRate;
    private double balance;

    public SavingAccount(double StartingBalance) {
        this.balance  = StartingBalance;
    }

    public void setAnnualRate ( double rate){
        this.annualRate = rate ;
    }

    public void deposit(double amount){
        balance += amount;
    }

    public void withdraw(double amount){
        balance -= amount;
    }

    public void addMonthlyInterest (){
        double monthlyRate = annualRate/12;
        balance *= (monthlyRate + 1);
    }
    public double getBalance(){
        return balance;
    }

    public double getMonthlyInterestAmount() {
         return balance * (annualRate / 12);
    }

    @Override
    public String toString() {
        return "SavingAccount Balance: " + getBalance() ;
    }
    
    
}
