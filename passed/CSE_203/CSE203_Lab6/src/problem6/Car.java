package problem6;

public class Car implements IDrivable,IPassengerCarrier{
    @Override
    public void drive() {
        System.out.println("Car is driving on the road.");
    }

    @Override
    public void passenger() {
        System.out.println("Car is able to carry 4 passengers in maximum.");
    }
}
