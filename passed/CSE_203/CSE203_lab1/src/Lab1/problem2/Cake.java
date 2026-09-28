package problem2;

public class Cake {
    private String cake;
    private int  tiers;
    private String day;
    public Cake(String cake, int tiers, String day) {
        this.cake = cake;
        this.tiers = tiers;
        this.day = day;
    }

    public String getCake() {
        return cake;
    }

    public void setCake(String cake) {
        this.cake = cake;
    }

    public int getTiers() {
        return tiers;
    }

    public void setTiers(int tiers) {
        this.tiers = tiers;
    }

    public String getDay() {
        return day;
    }

    public void setDay(String day) {
        this.day = day;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Cake : ").append(cake);
        sb.append(", Tiers : ").append(tiers);
        sb.append(", Day : ").append(day);
        return sb.toString();
    }

    
}
