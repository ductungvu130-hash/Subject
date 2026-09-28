package problem8;

public class Customer {
    private String name;
    private String address;
    private String phonenumber;

    public Customer(String address, String phonenumber, String name) {
        this.address = address;
        this.phonenumber = phonenumber;
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

    public String getphonenumber() {
        return phonenumber;
    }

    public void setphonenumber(String phonenumber) {
        this.phonenumber = phonenumber;
    }

    @Override
    public String toString() {
        return "Customer Name: " + getName() + ", Address: " + getAddress() + ", Phone number: " + getphonenumber()
                ;
    }
}
