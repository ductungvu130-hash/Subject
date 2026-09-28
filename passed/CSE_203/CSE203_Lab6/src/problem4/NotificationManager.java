package problem4;

public class NotificationManager {
    private final INotificationService notificationService;

    public NotificationManager(INotificationService notificationService) {
        this.notificationService = notificationService;
    }

    public void sendNotification(String message) {
        this.notificationService.send(message);
    }
}
