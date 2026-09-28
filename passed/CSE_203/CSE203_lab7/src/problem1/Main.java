package problem1;

public class Main {

    public static void main(String[] args) {
        Logger logger1 = Logger.getInstance();
        logger1.log("Application started.");

        Logger logger2 = Logger.getInstance();
        logger2.log("User logged in.");

        Logger logger3 = Logger.getInstance();
        logger3.log("Processing request.");

        System.out.println("Same instance: " + (logger1 == logger2 && logger2 == logger3));
    }
}
