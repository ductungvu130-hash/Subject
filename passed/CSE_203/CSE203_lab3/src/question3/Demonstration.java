package question3;

public class Demonstration {
    public static void main(String[] args) {
       
        double circleArea = Shape.getArea(5.0);
        System.out.printf("Square of circle: %.2f\n", circleArea);

        
        double rectArea = Shape.getArea(10, 20);
        System.out.printf("Square of rectangle: %.2f\n", rectArea);

        
        double cylArea = Shape.getArea(5.0, 10.0);
        System.out.printf("Square of cylnder: %.2f\n", cylArea);
    }
}

