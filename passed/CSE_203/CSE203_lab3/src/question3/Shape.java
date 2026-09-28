package question3;

public class Shape {
   
    public static double getArea(double radius) {
        return Math.PI * radius * radius;
    }

    
    public static double getArea(int width, int length) {
        return (double) width * length;
    }

    
    public static double getArea(double radius, double height) {
        return Math.PI * radius * radius * height;
    }
}