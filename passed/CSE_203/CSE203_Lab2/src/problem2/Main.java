package problem2;

public class Main {
    public static void main (String[]args) throws Exception{
    Car mycar = new Car(200, "TOYOTA");

    mycar.setSpeed(50);
    
    System.out.println(mycar.toString());
    
    for (int i =0 ; i < 5 ; i++){
        mycar.accelerate();
        System.out.println("Accelerating Current speed: " + mycar.getSpeed());
    }

    for (int i =0 ; i < 5 ; i++){
        mycar.brake();
        System.out.println("Braking Current speed: " + mycar.getSpeed());
    }
    }
}
