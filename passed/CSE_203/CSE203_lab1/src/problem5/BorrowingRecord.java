package problem5;

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

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public LocalDate getBorrowingDate() {
        return borrowingDate;
    }

    public void setBorrowingDate(LocalDate borrowingDate) {
        this.borrowingDate = borrowingDate;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }

    @Override
    public String toString() {
        return "Record: [" + user.getName() + " borrowed " + book.getTitle() + 
               " | Due: " + dueDate + "]";
    }
}