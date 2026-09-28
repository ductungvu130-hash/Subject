package problem1;

public class Problem1demo {
    public static void main(String[] args) throws Exception{
        Employee emp_1 = new Employee( "Susan Meyers" ,  47899 ,  "Accounting", "Vice President");
        Employee emp_2 = new Employee( "Mark Jones" ,  39119 ,  "IT", "Programer");
        Employee emp_3 = new Employee( "Joy Rogers" ,  81774 ,  "Manufacturing", "Engineer");

        System.out.println(emp_1.toString());
        System.out.println(emp_2.toString());
        System.out.println(emp_3.toString());
    }



}
