package problem1;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.FormatStyle;

public class SingletonPattern {
    private static SingletonPattern instance;

    private SingletonPattern() {

    }

    public static SingletonPattern getInstance() {
        if (instance == null) {
            instance = new SingletonPattern();
        }
        return instance;
    }

    public void log(String message) {
        String timeStamp = LocalDateTime.now().format(DateTimeFormatter.ofLocalizedDateTime(FormatStyle.MEDIUM));
        System.out.println("[" + timeStamp + "]. " + message);
    }
}
