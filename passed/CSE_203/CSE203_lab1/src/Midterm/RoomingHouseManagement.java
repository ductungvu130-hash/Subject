package Midterm;

import java.util.ArrayList;
import java.util.List;

public class RoomingHouseManagement {
    private String name;
    private List<Customer> customers;
    private List<Room> rooms;
    private List<Registration> registrations;

    public RoomingHouseManagement(String name) {
        this.name = name;
        this.customers = new ArrayList<>();
        this.rooms = new ArrayList<>();
        this.registrations = new ArrayList<>();
    }

    public void addNewCustomer(Customer customer) {
        customers.add(customer);
    }

    public void addRoom(Room room) {
        rooms.add(room);
    }

    // Functionality 4: Register a customer for a room
    public void register(Customer customer, Room room, long deposit) {
        // Logical check: If the room is already OCCUPIED
        if (room.getStatus() == RoomStatus.OCCUPIED) {
            System.out.println("Error: Room " + room.getId() + " is already occupied. Cannot register " + customer.getFullname() + ".");
            return;
        }

        Registration newReg = new Registration(customer, room, deposit);
        registrations.add(newReg);
        room.setStatus(RoomStatus.OCCUPIED);
        System.out.println("Registration successful: Room " + room.getId() + " assigned to " + customer.getFullname() + ".");
    }

    // Functionality 5: Show all customer fullnames
    public void showAllCustomer() {
        System.out.println("--- All Customer Fullnames at " + this.name + " ---");
        for (Customer c : customers) {
            System.out.println(c.getFullname());
        }
    }

    public void showAllRegistrations() {
        System.out.println("--- Current Registrations ---");
        for (Registration reg : registrations) {
            System.out.println(reg.toString());
        }
    }
}