package problem5;

public class Book {
    private String isbn;
    private String title;
    private boolean isAvailable;
    private int numberofbook;

    public Book(String title, String isbn, int numberofbook) {
        this.title = title;
        this.isbn = isbn;
        this.numberofbook = numberofbook;
        this.isAvailable = numberofbook > 0;
    }

    public String getIsbn() {
        return isbn;
    }

    public String getTitle() {
        return title;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean available) {
        isAvailable = available;
    }

    public int getnumberofbook() {
        return numberofbook;
    }

    public void setnumberofbook(int numberofbook) {
        this.numberofbook = numberofbook;
        this.isAvailable = numberofbook > 0;
    }

    
    public boolean checkIsAvailable() {
        return this.numberofbook > 0;
    }

    @Override
    public String toString() {
        return "Book{" + "isbn='" + isbn + '\'' + ", title='" + title + '\'' + ", numberofbook=" + numberofbook + '}';
    }
}