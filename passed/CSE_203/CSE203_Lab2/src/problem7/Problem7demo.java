package problem7;

public class Problem7demo {
    public static void main (String[] args) throws Exception{
        Customer cus1 = new Customer("New CiTy", "123123", "Tony");
        Car car1 = new Car("Toyota","SUV", "a month", 500000);
        Rental rent1 = new Rental(80000, 2000);
        System.out.println(cus1.toString());
        System.out.println(car1.toString());
        System.out.println(rent1.toString());
        System.out.println(rent1.totalcost(rent1));

    }

}
