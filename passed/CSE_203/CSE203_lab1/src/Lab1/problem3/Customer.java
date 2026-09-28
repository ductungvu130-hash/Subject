package problem3;

public class Customer {
    private String name;
    private String address;
    private String license;

    public Customer(String address, String license, String name) {
        this.address = address;
        this.license = license;
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getLicense() {
        return license;
    }

    public void setLicense(String license) {
        this.license = license;
    }

    @Override
    public String toString() {
        return "Customer Name: " + getName() + ", Address: " + getAddress() + ", License: " + getLicense()
                ;
    }
}
