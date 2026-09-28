package problem2;

public abstract class Employee {
    private String name;

    public Employee(String name) {
        this.name = name;
    }
    
    public abstract double calculatePay();

    public String getName() {
        return name;
    }
}
