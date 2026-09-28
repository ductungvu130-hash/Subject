package Midterm;

import java.time.LocalDate;

public class Customer {
    private String id;
    private String fullname;
    private String phone;
    private LocalDate startingDate;
    private LocalDate endDate;
    private boolean representative;

    public Customer() {
        this.id = "default customer ID";
        this.fullname = "";
    }

    public Customer(String id, String fullname, String phone) {
        this.id = id;
        this.fullname = fullname;
        // Phone number must start with 0
        if (phone != null && phone.startsWith("0")) {
            this.phone = phone;
        } else {
            this.phone = "0" + phone; 
        }
    }

    public boolean equals(Customer cus) {
        if (cus == null) return false;
        return this.id.equals(cus.id);
    }

    public String getId() { return id; }
    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }
}