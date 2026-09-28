package problem7;

public class Main {
    public static void main(String[] args) {
        Application myApp = new Application();

       
        myApp.loadPlugin(new SavePlugin());
        myApp.loadPlugin(new PrintPlugin());

        myApp.runPlugins();
    }
}
