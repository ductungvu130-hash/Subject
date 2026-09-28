package section1;

public abstract class AProduct {
    protected String license;
    protected  String brand;
    protected Double price;

    public AProduct(String brand, String license, Double price) {
        this.brand = brand;
        this.license = license;
        this.price = price;
    }
    

    public String getLicense() {
        return license;
    }


    public String getBrand() {
        return brand;
    }


    public Double getPrice() {
        return price;
    }


    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(this.getClass().getSimpleName()).append(" - ");        
        sb.append("Brand: ").append(this.brand);
        sb.append(" License=").append(this.license);
        return sb.toString();
    }

    public abstract Double caculateCost();


}
