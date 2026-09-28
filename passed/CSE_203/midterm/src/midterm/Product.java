package midterm;

public class Product {
    private String id;
    private String name;
    private long price;
    private ProductCategory category;
    public Product(String id, String name, long price, ProductCategory category) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.category = category;
    }
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public long getPrice() {
        return price;
    }
    public void setPrice(long price) {
        this.price = price;
    }
    public ProductCategory getCategory() {
        return category;
    }
    public void setCategory(ProductCategory category) {
        this.category = category;
    }

    public boolean equals(Product product1){
        if(product1 == null)return false;
        return this.id.equals(product1.id);
    }
}
