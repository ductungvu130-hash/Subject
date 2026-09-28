package problem2;

public class Main {

    public static void main(String[] args) {
        ShapeFactory factory = new CircleFactory();
        factory.getShape().draw();

        factory = new RectangleFactory();
        factory.getShape().draw();

        factory = new SquareFactory();
        factory.getShape().draw();
    }
}
