package Midterm;

import java.time.LocalDate;

public class Registration {
    private String id;
    private Customer customer;
    private Room room;
    private long depositAmount;
    private long currentElectricNumber;
    private long currentWaterNumber;
    private LocalDate rentDate;

    public Registration(Customer customer, Room room) {
        this.customer = customer;
        this.room = room;
        this.depositAmount = 0;
        this.rentDate = LocalDate.now();
    }

    public Registration(Customer customer, Room room, long depositAmount) {
        this.customer = customer;
        this.room = room;
        this.depositAmount = depositAmount;
        this.rentDate = LocalDate.now();
    }

    @Override
    public String toString() {
        // Format: <room ID>: <customer fullname>
        return room.getId() + ": " + customer.getFullname();
    }
}