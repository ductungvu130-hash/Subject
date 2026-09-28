package question4;

public class Fuelgauge {
    private int amountFuel;
    private static final int Max_Fuel = 15;

    public Fuelgauge() {
        amountFuel = 0;
    }

    public int getAmountFuel() {
        return amountFuel;
    }

    public void setAmountFuel(int amountFuel) {
        this.amountFuel = amountFuel;
    }

    public void puttingFuel(){
        if(this.amountFuel < Max_Fuel){
            this.amountFuel ++;
        }
    }

    public void burningFuel(){
        if(this.amountFuel > 0){
            this.amountFuel--;
        }
    }

    

}
