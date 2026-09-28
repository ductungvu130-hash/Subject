package problem4;

public class Main {
    public static void main(String[] args) {
        INotificationService emailService = new EmailService();
        INotificationService smsService = new SMSService();
        INotificationService pushService = new PushNotificationService();

        
        NotificationManager manager = new NotificationManager(emailService);
        manager.sendNotification("Your server is down!");

        manager = new NotificationManager(smsService);
        manager.sendNotification("Your server is down!");

        manager = new NotificationManager(pushService);
        manager.sendNotification("Your server is down!");
    }
}