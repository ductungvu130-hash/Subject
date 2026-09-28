package problem5;

public class SMSSubscriber implements Observer {

    private String phoneNumber;

    public SMSSubscriber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    @Override
    public void update(String message) {
        System.out.println("SMS Subscriber [" + phoneNumber + "]: " + message);
    }
}
