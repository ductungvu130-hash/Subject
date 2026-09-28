package midterm;

public class Customer {
    private String id;
    private String fullname;
    private String phoneNumber;

    public Customer() {
        this.id = "";
        this.fullname = "";
        this.phoneNumber = "";
    }

    public Customer(String id, String fullname, String phoneNumber) {
        this.id = id;
        this.fullname = fullname;
        if(phoneNumber != null && phoneNumber.startsWith("0")){
            this.phoneNumber= phoneNumber;
        }
        else{
            this.phoneNumber = "0"+phoneNumber;
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public boolean equals(Customer cus){
        if(cus == null)return false;
        return this.id.equals(cus.id);
    }

    @Override
    public String toString() {
        return getId() + ", Full name: " + getFullname() + ", Phone Number: "
                + getPhoneNumber();
    }

    
}
