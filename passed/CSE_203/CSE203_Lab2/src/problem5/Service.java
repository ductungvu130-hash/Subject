package problem5;

public class Service {
    private int grooming;
    private int charges;
    private static final double salesTaxRate =0.08;

    
    public Service(int grooming, int charges) {
        this.grooming = grooming;
        this.charges = charges;
    }


    public int getGrooming() {
        return grooming;
    }


    public void setGrooming(int grooming) {
        this.grooming = grooming;
    }


    public int getCharges() {
        return charges;
    }


    public void setCharges(int charges) {
        this.charges = charges;
    }

    public double totalcost (Service s){
        return (s.getGrooming()+s.getCharges())* (1 + salesTaxRate);
    }


    @Override
    public String toString() {
        return "Service: " + getGrooming() + ", Charges: " + getCharges();
    }

    

    
}
