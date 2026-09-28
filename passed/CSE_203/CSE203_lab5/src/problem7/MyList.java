package problem7;


import java.util.ArrayList;
import java.util.Comparator;
import java.util.NoSuchElementException;

public class MyList<T extends Comparable<T>> {
    private ArrayList<T> list;

    public MyList() {
        this.list = new ArrayList<>();
    }

    public void add(T number) {
        list.add(number);
    }

    public T largest() {
        if (list == null || list.isEmpty()) {
            throw new NoSuchElementException("Do not any element existed");
        }


        T max = list.get(0);
        for (T value : list) {
            if (value.compareTo(max) > 0) {
                max = value;
            }
        }
        return max;
    }

    public T lowest() {
        if (list == null || list.isEmpty()) {
            throw new NoSuchElementException("Do not any element existed");
        }

        T min = list.get(0);
        for (T value : list) {
            if (value.compareTo(min) < 0) {
                min = value;
            }
        }
        return min;
    }

    public String display() {
        StringBuilder oBuider = new StringBuilder();
        for (T value : list) {
            oBuider.append(value).append(" ");
        }
        return oBuider.toString();
    }
}
