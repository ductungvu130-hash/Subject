package problem9;

public class SavingsAccount extends BankAccount {
    private boolean active; // Trạng thái tài khoản [cite: 87]

    public SavingsAccount(double balance, double annualInterestRate) {
        super(balance, annualInterestRate);
        // Tài khoản không hoạt động nếu số dư dưới $25 [cite: 88]
        this.active = balance >= 25;
    }

    @Override
    public void withdraw(double amount) {
        if (!active) {
            System.out.println("Your accont is blocked");
        } else {
            super.withdraw(amount);
            if (balance < 25) active = false; // Kiểm tra lại trạng thái sau khi rút [cite: 88, 90]
        }
    }

    @Override
    public void deposit(double amount) {
        if (!active && (balance + amount) >= 25) {
            active = true; // Kích hoạt lại nếu tiền gửi giúp số dư >= $25 
        }
        super.deposit(amount);
    }

    @Override
    public void monthlyProcess() {
        // Nếu rút hơn 4 lần, mỗi lần sau đó phí $1 
        if (numWithdrawals > 4) {
            monthlyServiceCharges += (numWithdrawals - 4);
        }
        super.monthlyProcess();
        
        // Kiểm tra trạng thái sau khi trừ phí dịch vụ 
        if (balance < 25) {
            active = false;
        }
    }

    @Override
    public String toString() {
        return "Amount: $" + String.format("%.2f", balance) + 
               " | Status: " + (active ? "Active" : "Blocked") +
               " | Number of withdrawals: " + numWithdrawals;
    }
}