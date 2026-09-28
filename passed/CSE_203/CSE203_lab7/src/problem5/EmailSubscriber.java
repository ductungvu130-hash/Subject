package problem5;

public class EmailSubscriber implements Observer {

    private String email;

    public EmailSubscriber(String email) {
        this.email = email;
    }

    @Override
    public void update(String message) {
        System.out.println("Email Subscriber [" + email + "]: " + message);
    }
}
