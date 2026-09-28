package problem7_8;

public class Customer extends Person {
    private String customerNumber;
    private boolean mailingList;

    public Customer(String name, String address, String telephone, String customerNumber, boolean mailingList) {
        super(name, address, telephone);
        this.customerNumber = customerNumber;
        this.mailingList = mailingList;
    }

    // Accessors and Mutators [cite: 66]
    public String getCustomerNumber() { return customerNumber; }
    public void setCustomerNumber(String customerNumber) { this.customerNumber = customerNumber; }
    public boolean isMailingList() { return mailingList; }
    public void setMailingList(boolean mailingList) { this.mailingList = mailingList; }
}
