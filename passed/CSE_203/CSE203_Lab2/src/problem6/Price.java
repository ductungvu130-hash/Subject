package problem6;

public class Price {
    private int ingredients;
    private int charges;
    private int delivery;
    private static final double salesTaxRate =0.08;


    public Price(int ingredients, int charges, int delivery) {
        this.ingredients = ingredients;
        this.charges = charges;
        this.delivery = delivery;
    }
    public int getIngredients() {
        return ingredients;
    }
    public void setIngredients(int ingredients) {
        this.ingredients = ingredients;
    }
    public int getCharges() {
        return charges;
    }
    public void setCharges(int charges) {
        this.charges = charges;
    }
    public int getDelivery() {
        return delivery;
    }
    public void setDelivery(int delivery) {
        this.delivery = delivery;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
       
        sb.append("Ingredients : ").append(ingredients);
        sb.append(", Charges : ").append(charges);
        sb.append(", Delivery : ").append(delivery);
        
        return sb.toString();
    }

    public double totalcost (Price p){
        return (p.getCharges() + p.getDelivery() + p.getIngredients())*(1 + salesTaxRate);
    }
    
    

}
