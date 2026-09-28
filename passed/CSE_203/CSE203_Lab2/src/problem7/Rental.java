package problem7;

public class Rental {
    private int baseFee;
    private int milageFee;
    private static final double tax = 0.08;


    public Rental(int baseFee, int milageFee) {
        this.baseFee = baseFee;
        this.milageFee = milageFee;
    }


    public int getBaseFee() {
        return baseFee;
    }


    public void setBaseFee(int baseFee) {
        this.baseFee = baseFee;
    }


    public int getMilageFee() {
        return milageFee;
    }


    public void setMilageFee(int milageFee) {
        this.milageFee = milageFee;
    }

    
    public double totalcost (Rental r){
        return (r.baseFee + r.milageFee)*(1 + tax);
    }


    @Override
    public String toString() {
        return "Rental Base Fee: " + getBaseFee() + ", Milage Fee: " + getMilageFee() ;
    }

    
}
