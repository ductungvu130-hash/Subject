package question2;

import java.util.Scanner;
import question1.RetailItem;

public class Demonstration2 {
    public static void main(String[]args){
        Scanner sc = new Scanner(System.in);
        RetailItem item1 = new RetailItem("Item #1: Jacket", 12, 59.95);
        CashRegister cash1 = new CashRegister(0, item1);

        System.out.println("How many units of items ?");
        int quantity = sc.nextInt();

        cash1.setQuantity(quantity);

        System.out.println(cash1.toString());

    }

}
