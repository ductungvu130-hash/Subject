package problem5;

public class problem5demo {
    public static void main (String[] args) throws Exception{
        Customer cus1 = new Customer("Tony", "HCM", "045678");
        Pet pet1 = new Pet("5", "dog" , 20);
        Service ser1 = new Service(200, 600);

        System.out.println(cus1.toString());
        System.out.println(pet1.toString());
        System.out.println(ser1.toString());

        System.out.println("Total cost: " + ser1.totalcost(ser1));

    }

}
