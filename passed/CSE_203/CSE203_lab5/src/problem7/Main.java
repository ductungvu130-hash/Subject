package problem7;

import problem6.MyList;

public class Main {
    public static void main(String[] args) {
        MyList<Integer> listInt = new MyList<>();

        System.out.println("Largest: "+listInt.largest());

        listInt.add(1);
        listInt.add(20);
        listInt.add(103);
        listInt.add(-22);
        listInt.add(0);

        System.out.println("All elements: "+listInt.display());
        System.out.println("Largest: "+listInt.largest());
        System.out.println("Lowest: "+listInt.lowest());
    }
}
