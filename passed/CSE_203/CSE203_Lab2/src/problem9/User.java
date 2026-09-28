package problem9;

import java.time.LocalDate;
import java.util.ArrayList;

public class User {
    private String id;
    private String name;
    private String email;
    private ArrayList<Book> borrowedBooks;
    private ArrayList<BorrowingRecord> privateRecords;

    public User(String id, String name, String email) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.borrowedBooks = new ArrayList<>();
        this.privateRecords = new ArrayList<>();
    }

    
    public void borrow(Book book, LocalDate borrowDate, LocalDate dueDate) {
        if (book.checkIsAvailable()) {
           
            BorrowingRecord record = new BorrowingRecord(this, book, borrowDate, dueDate);
            
            
            this.privateRecords.add(record);
            this.borrowedBooks.add(book);
            
           
            book.setnumberofbook(book.getnumberofbook() - 1);
            
            System.out.println("User: " + this.name + " borrowed " + book.getTitle());
        } else {
            System.out.println("Fail: Book is not available.");
        }
    }

    
    public int getOverdueBooks() {
        int count = 0;
        LocalDate today = LocalDate.now();
        
        for (BorrowingRecord record : privateRecords) {
            
            if (record.getDueDate().isBefore(today)) {
                count++;
            }
        }
        return count;
    }

    public ArrayList<BorrowingRecord> getPrivateRecords() {
        return privateRecords;
    }
    
    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return "User{id='" + id + "', name='" + name + "', overdue=" + getOverdueBooks() + "}";
    }
}