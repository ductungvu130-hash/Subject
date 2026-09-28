package problem1;

class Triangle implements Shape {
    private double height;
    private double base;

    public Triangle(double base, double height) {
        this.base = base;
        this.height = height;
    }
    
    
    
    @Override
    public void draw(){
        System.out.println("Draw triangle | height : " + this.height + " | base : " + this.base);
    }
    
    @Override
    public double calculateArea() {
        return (this.base * this.height)/2;
    }
}
