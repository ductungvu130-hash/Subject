package problem4;

public class PushNotificationService implements INotificationService {
@Override
    public void send(String message){
        System.out.println("Send message by push notification :" + message);
    }
}
