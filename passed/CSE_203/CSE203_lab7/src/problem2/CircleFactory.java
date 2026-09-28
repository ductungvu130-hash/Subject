package problem2;

public class CircleFactory extends ShapeFactory {

    @Override
    public Shape getShape() {
        return new Circle();
    }
}
