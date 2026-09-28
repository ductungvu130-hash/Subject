package problem6;

public class Main {
    public static void main(String[] args) {
        MyList<Integer> listInt = new MyList<>();
        MyList<Double> listDouble = new MyList<>();

        for(int i=10;i<50;i+=4){
            listInt.add(i-10*2);
            listDouble.add(i*2.4);
        }
        System.out.println("<===== Integer List =====>");
        System.out.println("All elements: "+listInt.display());
        System.out.println("Largest: "+listInt.largest());
        System.out.println("Lowest: "+listInt.lowest());

        System.out.println("<===== Double List =====>");
        System.out.println("All elements: "+listDouble.display());
        System.out.println("Largest: "+listDouble.largest());
        System.out.println("Lowest: "+listDouble.lowest());

    }
}
