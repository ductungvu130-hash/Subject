package section1;

public class Customer {
    private String id;
    private String name;
    private String phoneNumber;


    public Customer(String id, String name, String phoneNumber) {
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

    public String getPhoneNumber() {
        return phoneNumber;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Name: ").append(this.name).append(" | ");
        sb.append("ID:").append(this.id);
        return sb.toString();
    }

    
    

}
