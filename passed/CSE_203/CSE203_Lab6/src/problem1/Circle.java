package problem1;

class Circle implements Shape {
    private double radius;

    public Circle(double radius) {
        this.radius = radius;
    }

    @Override
    public void draw(){
        System.out.println("Draw circle | radius : " + this.radius);
    }
    
    @Override
    public double calculateArea() {
        return Math.PI * Math.pow(radius, 2);
    }
}
