package problem5_remake;

public class Book {
    private String ISBN;
    private String title;
    
    public Book(String ISBN, String title) {
        this.ISBN = ISBN;
        this.title = title;       
    }

    public String getISBN() {
        return ISBN;
    }

    public void setISBN(String ISBN) {
        this.ISBN = ISBN;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

}
