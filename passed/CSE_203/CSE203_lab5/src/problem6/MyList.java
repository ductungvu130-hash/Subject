package problem6;

import java.util.ArrayList;
import java.util.Comparator;

public class MyList<T extends Number> {
    private ArrayList<T> list;

    public MyList() {
        this.list = new ArrayList<>();
    }

    public void add(T number){
        list.add(number);
    }

    public T largest(){
        T max = list.get(0);
        for(T value:list){
            if (value.doubleValue()>max.doubleValue()){
                max=value;
            }
        }
        return max;
    }

    public T lowest(){
        T min = list.get(0);
        for(T value:list){
            if (value.doubleValue()<min.doubleValue()){
                min=value;
            }
        }
        return min;
    }
    public String display(){
        StringBuilder oBuider=new StringBuilder();
        for(T value:list){
            oBuider.append(value).append(" ");
        }
        return oBuider.toString();
    }
}
