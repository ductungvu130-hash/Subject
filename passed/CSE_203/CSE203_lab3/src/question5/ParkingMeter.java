package question5;

public class ParkingMeter {
    private int purchasedTime;

    public ParkingMeter(int purchasedTime) {
        this.purchasedTime = purchasedTime;
    }

    public int getPurchasedTime() {
        return purchasedTime;
    }

    public void setPurchasedTime(int purchasedTime) {
        this.purchasedTime = purchasedTime;
    }

    @Override
    public String toString() {
        return "Purchased Time: " + getPurchasedTime() ;
    }

    
    

}
