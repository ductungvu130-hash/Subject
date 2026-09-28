package problem5_remake;

import java.time.LocalDate;

public class Main {
    public static void main(String[] args) {
        Administrator admin = new Administrator();

        // Chuẩn bị sách
        Book b1 = new Book("ISBN-1", "Java 101");
        Book b2 = new Book("ISBN-2", "SQL Basics");
        Book b3 = new Book("ISBN-3", "Algorithms");
        admin.addBook(b1);
        admin.addBook(b2);
        admin.addBook(b3);

        // Chuẩn bị User
        User alice = new User("U1", "Alice", "alice@test.com");
        User bob = new User("U2", "Bob", "bob@test.com");

        System.out.println(" Case 1: Successful borrowing");
        // Alice mượn sách b1 trong 7 ngày
        admin.processBorrowing(alice, b1, 7);

        System.out.println("\n Case 2: Book not available");
        // Bob cố mượn sách b1 (Alice đã lấy)
        admin.processBorrowing(bob, b1, 5);

        System.out.println("\n Case 3: User has exactly 1 overdue ");
        // Giả lập Bob có 1 cuốn quá hạn
        BorrowingRecord over1 = new BorrowingRecord(bob, new Book("X", "Old Book 1"), 
                LocalDate.now().minusDays(10), LocalDate.now().minusDays(5));
        bob.addRecord(over1);
        admin.processBorrowing(bob, b2, 10); // Vẫn được mượn vì chỉ mới quá hạn 1 cuốn

        System.out.println("\n Case 4: User has more than 1 overdue (DENIED)");
        // Giả lập Bob có thêm 1 cuốn nữa quá hạn (tổng cộng 2)
        BorrowingRecord over2 = new BorrowingRecord(bob, new Book("Y", "Old Book 2"), 
                LocalDate.now().minusDays(10), LocalDate.now().minusDays(2));
        bob.addRecord(over2);
        admin.processBorrowing(bob, b3, 5); // Bị từ chối vì > 1 cuốn quá hạn
    }
}