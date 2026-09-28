package problem3;

public class MilkDecorator extends BaseDecorator {

    public MilkDecorator(Coffee coffee) {
        super(coffee);
    }

    @Override
    public double getCost() {
        return super.getCost() + 1.5;
    }

    @Override
    public String getDescription() {
        return super.getDescription() + " + Milk";
    }
}
