package problem5_remake;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class Administrator {
    private List<Book> allBooks;
    private List<BorrowingRecord> allRecords;

    public Administrator() {
        this.allBooks = new ArrayList<>();
        this.allRecords = new ArrayList<>();
    }

    // GHI CHÚ: Logic mượn sách và tính Due Date
    public void processBorrowing(User user, Book book, int daysToBorrow) {
        // 1. Kiểm tra tính sẵn có của sách
        if (!allBooks.contains(book)) {
            System.out.println("FAILED: Book '" + book.getTitle() + "' is not available.");
            return;
        }

        // 2. Kiểm tra điều kiện của User (không quá 1 cuốn quá hạn)
        if (!user.isEligible()) {
            System.out.println("FAILED: User " + user.getName() + " has more than one overdue book.");
            return;
        }

        // 3. TÍNH TOÁN: Due Date = Ngày mượn + số ngày muốn mượn
        LocalDate borrowingDate = LocalDate.now();
        LocalDate dueDate = borrowingDate.plusDays(daysToBorrow); // ĐÂY LÀ DÒNG BẠN YÊU CẦU

        // 4. Tạo record và cập nhật hệ thống
        BorrowingRecord record = new BorrowingRecord(user, book, borrowingDate, dueDate);
        allRecords.add(record);
        user.addRecord(record);
        allBooks.remove(book); // Sách đã mượn nên không còn trong kho sẵn có

        System.out.println("SUCCESS: " + record);
    }

    public void addBook(Book book) { allBooks.add(book); }
}