package problem6;

public class problem6demo {
    public static void main(String[] args) throws Exception {
       
    Customer cus1 = new Customer("Tony", "HCM", "012314");
    Cake cake1 = new Cake("brithday", 4, "06/05/2020");
    Price price1 = new Price(500, 200, 100);

    System.out.println(cus1.toString());
    System.out.println(cake1.toString());
    System.out.println(price1.toString());
    System.out.println("Total cost : "+ price1.totalcost(price1));
}
}