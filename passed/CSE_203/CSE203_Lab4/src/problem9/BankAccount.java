package problem9;

public abstract class BankAccount {
    protected double balance; 
    protected int numDeposits; 
    protected int numWithdrawals; 
    protected double annualInterestRate; 
    protected double monthlyServiceCharges; 

    // Constructor 
    public BankAccount(double balance, double annualInterestRate) {
        this.balance = balance;
        this.annualInterestRate = annualInterestRate;
        this.numDeposits = 0;
        this.numWithdrawals = 0;
        this.monthlyServiceCharges = 0;
    }

    // Gửi tiền 
    public void deposit(double amount) {
        balance += amount;
        numDeposits++;
    }

    // Rút tiền 
    public void withdraw(double amount) {
        balance -= amount;
        numWithdrawals++;
    }

    // Tính lãi suất hàng tháng 
    public void calcInterest() {
        double monthlyInterestRate = (annualInterestRate / 12);
        double monthlyInterest = balance * monthlyInterestRate;
        balance = balance + monthlyInterest;
    }

    // Xử lý cuối tháng 
    public void monthlyProcess() {
        balance -= monthlyServiceCharges;
        calcInterest();
        numDeposits = 0;
        numWithdrawals = 0;
        monthlyServiceCharges = 0;
    }
}