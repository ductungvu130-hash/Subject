package section1;

public class Medicine extends  AProduct {
    private String lotNumber;

    public Medicine(String brand, String license, Double price, String lotNumber) {
        super(brand, license, price);
        this.lotNumber = lotNumber;
    }

    @Override
    public Double caculateCost(){
        return this.price + (this.price * 0.1);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(this.brand).append(" : ");
        sb.append(this.caculateCost());
        sb.append(" - ");
        sb.append(this.license);
        return sb.toString();
    }

    
}
