package problem4;

public class EmailService implements INotificationService {
    @Override
    public void send(String message){
        System.out.println("Send message by email :" + message);
    }
}
