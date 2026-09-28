package problem5_remake;

import java.time.LocalDate;

public class BorrowingRecord {
    private User user;
    private Book book;
    private LocalDate borrowingDate;
    private LocalDate dueDate;

    public BorrowingRecord(User user, Book book, LocalDate borrowingDate, LocalDate dueDate) {
        this.user = user;
        this.book = book;
        this.borrowingDate = borrowingDate;
        this.dueDate = dueDate;
    }

    public LocalDate getDueDate() { return dueDate; }

    @Override
    public String toString() {
        return "Record [User: " + user.getName() + ", Book: " + book.getTitle() + 
               ", Borrow Date: " + borrowingDate + ", Due Date: " + dueDate + "]";
    }
}