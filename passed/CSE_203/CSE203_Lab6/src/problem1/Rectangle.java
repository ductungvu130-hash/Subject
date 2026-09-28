package problem1;

class Rectangle implements Shape{
    private double length;
    private double width;

    public Rectangle(double length, double width) {
        this.length = length;
        this.width = width;
    }

    @Override
    public void draw(){
        System.out.println("Draw rectangle | length : " + this.length + " | width : " + this.width);
    }
    
    @Override
    public double calculateArea() {
        return this.length * this.width;
    }
    
}
