package problem5;

public class Main {

    public static void main(String[] args) {
        NewsAgency agency = new NewsAgency();

        Observer emailSubscriber = new EmailSubscriber("alice@example.com");
        Observer smsSubscriber = new SMSSubscriber("0901234567");

        agency.addObserver(emailSubscriber);
        agency.addObserver(smsSubscriber);

        agency.publishNews("Breaking News: Major earthquake hits the coast!");

        System.out.println();

        agency.removeObserver(smsSubscriber);
        agency.publishNews("Update: Relief teams have been deployed.");
    }
}
