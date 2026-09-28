package problem4;
import java.util.Scanner;

public class Main {
    public static void main (String[]args){

        Scanner sc = new Scanner(System.in);

        System.out.println("What is the annual interest rate? ");
        double annualRate= sc.nextDouble();
        
        System.out.println("What is the starting balance ?");
        double startingBalance = sc.nextDouble();

        System.out.println("How many months the account was established?");
        int month = sc.nextInt();

        SavingAccount acc1 = new SavingAccount(startingBalance);
        acc1.setAnnualRate(annualRate);

        double totalDeposit =0.0;
        double totalWithdrawals = 0.0;
        double totalInterest = 0.0;

        for (int i = 0 ; i< month ; i++){
            System.out.println("How much money of deposit adding to the account?");
            double deposit = sc.nextDouble();
            totalDeposit += deposit;
            acc1.deposit(deposit);

            System.out.println("How much money of withdrawn ?");
            double withdrawn = sc.nextDouble();
            totalWithdrawals += withdrawn;
            acc1.withdraw(withdrawn);

            totalInterest += acc1.getMonthlyInterestAmount() ;

            acc1.addMonthlyInterest();
            
            
        }
        
        System.out.printf("Starting Balance: %.2f\n", startingBalance);
        System.out.printf("Ending Balance: %.2f\n", acc1.getBalance());
        System.out.printf("Total amount of deposit: %.2f\n", totalDeposit);
        System.out.printf("Total amount of withdrawals: %.2f\n", totalWithdrawals);
        System.out.printf("Total amount of interest: %.2f\n", totalInterest);
        System.out.println("--------------------------------");

    }

}
