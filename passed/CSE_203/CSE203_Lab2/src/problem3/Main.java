package problem3;
import java.util.Scanner;

public class Main {
    public static void main (String[]args){
        Scanner sc = new Scanner(System.in);
        System.out.println("What is the Fahrenheit temperature now ? ");
        double nowtemp = sc.nextDouble();
        Temperature temp1 = new Temperature(nowtemp);

        System.out.println("Fahreheit temperature: "+ temp1.getFahrenheit()+ " , Celsius temperature: " + temp1.getCelius()  + ", Kelvin temperature: " + temp1.getKelvin());
    }

}
