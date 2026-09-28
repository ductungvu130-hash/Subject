package problem9;

public class BankDemo {
    public static void main(String[] args) {
        // Khởi tạo tài khoản tiết kiệm với $100 và lãi suất 5%
        SavingsAccount mySavings = new SavingsAccount(100.0, 0.05);
        
        System.out.println(mySavings);

        
        mySavings.withdraw(10.0);
        mySavings.withdraw(10.0);
        mySavings.withdraw(10.0);
        mySavings.withdraw(10.0);
        mySavings.withdraw(10.0); 

        // Rút số tiền lớn để tài khoản bị khóa
        mySavings.withdraw(40.0);
        System.out.println("After withdrawing : " + mySavings);

        // Thử rút khi tài khoản đã bị khóa
        mySavings.withdraw(5.0);

        // Gửi tiền để kích hoạt lại
        mySavings.deposit(30.0);
        System.out.println("After adding money: " + mySavings);

        // Xử lý cuối tháng
        mySavings.monthlyProcess();
        System.out.println("After monthly process: " + mySavings);
    }
}