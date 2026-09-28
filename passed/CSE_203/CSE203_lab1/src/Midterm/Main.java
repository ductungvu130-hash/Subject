package Midterm;

public class Main {
    public static void main(String[] args) {
        // 1. Initialize Management System
        RoomingHouseManagement system = new RoomingHouseManagement("Luxury Rooming House");

        // 2. Create and Add Customers
        Customer c1 = new Customer("C001", "John Wick", "0912345678");
        Customer c2 = new Customer("C002", "Tony Stark", "888999111"); // Will auto-prefix with 0
        system.addNewCustomer(c1);
        system.addNewCustomer(c2);

        // 3. Create and Add Rooms
        Room r1 = new Room("R101", 30.5, 5000000);
        Room r2 = new Room("R102", 20.0, 3500000);
        system.addRoom(r1);
        system.addRoom(r2);

        // 4. Demonstrate showAllCustomer
        system.showAllCustomer();
        System.out.println();

        // 5. Successful Registration
        system.register(c1, r1, 2000000);

        // 6. FAILED Registration (Room is already occupied)
        System.out.println("\n--- Testing Occupied Room Scenario ---");
        system.register(c2, r1, 1000000); 

        // 7. Successful Registration for second customer in a vacant room
        system.register(c2, r2, 1500000);

        // 8. Demonstrate showAllRegistrations (using toString)
        System.out.println();
        system.showAllRegistrations();
    }
}