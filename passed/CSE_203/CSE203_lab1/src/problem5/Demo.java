package problem5;

import java.time.LocalDate;

public class Demo {
    public static void main(String[] args) throws Exception{
        
        Administrator admin = new Administrator();

        
        Book b1 = new Book("Java Programming", "ISBN-001", 2);
        Book b2 = new Book("Data Structures", "ISBN-002", 1);
        admin.addBook(b1);
        admin.addBook(b2);

        
        User u1 = new User("U001", "Nguyen Van A", "a@eiu.edu.vn");
        User u2 = new User("U002", "Tran Thi B", "b@eiu.edu.vn");
        admin.addUser(u1);
        admin.addUser(u2);

        System.out.println("=== Case 1 : successful borrowing");
        
        if (admin.checkAvailable(u1, b1)) {
            
            u1.borrow(b1, LocalDate.now(), LocalDate.now().plusDays(7));
        }
        admin.printAllRecord();

        System.out.println("\n=== Case 2 : Book is not available");
        
        if (admin.checkAvailable(u2, b2)) {
            u2.borrow(b2, LocalDate.now(), LocalDate.now().plusDays(5));
        }
        
        if (admin.checkAvailable(u1, b2)) {
            u1.borrow(b2, LocalDate.now(), LocalDate.now().plusDays(5));
        }

        System.out.println("\n=== Case 3 : User have the overdue books");
        
        u2.borrow(b1, LocalDate.now().minusDays(20), LocalDate.now().minusDays(10)); 
        
        u2.borrow(b1, LocalDate.now().minusDays(20), LocalDate.now().minusDays(5));
        
        System.out.println("User B overdue count: " + u2.getOverdueBooks());
        
        
        if (admin.checkAvailable(u2, b1)) {
            u2.borrow(b1, LocalDate.now(), LocalDate.now().plusDays(3));
        } else {
            System.out.println("User B cannot borrow more books.");
        }
    }
}