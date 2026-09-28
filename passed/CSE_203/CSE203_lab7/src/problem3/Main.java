package problem3;

public class Main {

    public static void main(String[] args) {
        Coffee coffee = new SimpleCoffee();
        System.out.println("Description: " + coffee.getDescription());
        System.out.printf("Cost: $%.2f%n%n", coffee.getCost());

        coffee = new MilkDecorator(coffee);
        coffee = new SugarDecorator(coffee);
        System.out.println("Description: " + coffee.getDescription());
        System.out.printf("Cost: $%.2f%n%n", coffee.getCost());

        coffee = new WhippedCreamDecorator(coffee);
        System.out.println("Description: " + coffee.getDescription());
        System.out.printf("Cost: $%.2f%n", coffee.getCost());
    }
}
