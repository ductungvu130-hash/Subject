package problem1;

import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List <Shape> shape = new ArrayList<>();

        shape.add(new Circle(6.0));
        shape.add(new Rectangle(20, 3));
        shape.add(new Triangle(10, 20));

        for(Shape shapes : shape){
            shapes.draw();
            System.out.printf("Area : %.2f\n", shapes.calculateArea());
        }
    }
}
