package problem4;

public class SMSService implements INotificationService{
    @Override
    public void send(String message){
        System.out.println("Send message by SMS :" + message);
    }
}
