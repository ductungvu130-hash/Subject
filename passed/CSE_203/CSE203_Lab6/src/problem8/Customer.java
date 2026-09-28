package problem8;

public class Customer {
    private String id;
    private String name;
    private String email;
    private String phoneNumber;

    public Customer(String email, String id, String name, String phoneNumber) {
        this.email = email;
        this.id = id;
        this.name = name;
        this.phoneNumber = phoneNumber;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }


}
