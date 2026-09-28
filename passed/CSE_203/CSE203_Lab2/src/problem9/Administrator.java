package problem9;

import java.util.ArrayList;

public class Administrator {
    private ArrayList<Book> books;
    private ArrayList<User> users;
    private ArrayList<BorrowingRecord> records;

    public Administrator() {
        this.books = new ArrayList<>();
        this.users = new ArrayList<>();
        this.records = new ArrayList<>();
    }

    public void addBook(Book book) {
        books.add(book);
    }

    public void removeBook(Book book) {
        books.remove(book);
    }

    public void addUser(User user) {
        users.add(user);
    }

    public void removeUser(User user) {
        users.remove(user);
    }

    
    public boolean checkAvailable(User target, Book bookTarget) {
        
        if (!bookTarget.checkIsAvailable()) {
            System.out.println("Check: Book '" + bookTarget.getTitle() + "' is out of stock.");
            return false;
        }

        
        int overdueCount = target.getOverdueBooks();
        if (overdueCount > 1) {
            System.out.println("Check: User " + target.getName() + " is blocked (Overdue books: " + overdueCount + ").");
            return false;
        }

        return true;
    }

    
    public void updateRecords() {
        records.clear();
        for (User u : users) {
            records.addAll(u.getPrivateRecords());
        }
    }

    public void printAllRecord() {
        updateRecords(); 
        System.out.println("--- All Borrowing Records ---");
        for (BorrowingRecord r : records) System.out.println(r);
    }
}