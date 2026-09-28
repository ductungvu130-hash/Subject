package problem2;

import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {

        List<Employee> employList = new ArrayList<>();
        
        employList.add( new FullTimeEmployee("Tony", 3_012_300));
        employList.add( new PartTimeEmployee("Ting", 25.5, 70.0));

        for(Employee employ : employList){
            System.out.println(employ.toString());
        }
    }


}
