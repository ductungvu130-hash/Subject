package midterm;

public class OrderItem {
    private Product product;
    private long quantity;
    private static double TAX = 0.08;
    
    public OrderItem(Product product, long quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public long getQuantity() {
        return quantity;
    }

    public void setQuantity(long quantity) {
        this.quantity = quantity;
    }

    public double getTotalCost(){
        return (product.getPrice()* quantity * (1+ TAX));
    }
}
