package problem2;

public class RectangleFactory extends ShapeFactory {

    @Override
    public Shape getShape() {
        return new Rectangle();
    }
}
