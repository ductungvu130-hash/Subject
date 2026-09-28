package question4;


public class Odometer {
    private long currentMilage;
    private static final long MaxMilage = 999999;
    private int mileTraveled = 0;

    public Odometer(long currentMilage) {
        this.currentMilage = currentMilage;
    }

    public long getCurrentMilage() {
        return currentMilage;
    }

    public void setCurrentMilage(long currentMilage) {
        this.currentMilage = currentMilage;
    }

    public void addMile( Fuelgauge fuelgauge){
        if(currentMilage < MaxMilage){
            this.currentMilage++;
        }else if (currentMilage == MaxMilage) {
            currentMilage = 0;
        }

        mileTraveled++;
        if(mileTraveled == 24){
            fuelgauge.burningFuel();
            mileTraveled =0 ;
        }

    }


    
}
