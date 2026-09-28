package problem3;

public class SimpleCoffee implements Coffee {

    @Override
    public double getCost() {
        return 2.0;
    }

    @Override
    public String getDescription() {
        return "Simple Coffee";
    }
}
