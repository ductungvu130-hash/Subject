package section1;

public class Toy extends AProduct {
    private String manufacturedCountry;

    public Toy(String brand, String license, Double price, String manufacturedCountry) {
        super(brand, license, price);
        this.manufacturedCountry = manufacturedCountry;
    }

    @Override
    public Double caculateCost(){
        return this.price + (this.price * 0.08);
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
