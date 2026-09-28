package problem5;

public class NewsAgency extends Subject {

    public void publishNews(String news) {
        System.out.println("[NewsAgency] Publishing: " + news);
        notifyObservers(news);
    }
}
