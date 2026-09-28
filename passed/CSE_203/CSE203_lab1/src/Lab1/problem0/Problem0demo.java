package problem0;

public class Problem0demo {
    public static void main(String[] args) throws Exception{
        Employee emp_1 = new Employee( "Susan Meyers" ,  47899 ,  "Accounting", "Vice President");
        Employee emp_2 = new Employee( "Mark Jones" ,  39119 ,  "IT", "Programer");
        Employee emp_3 = new Employee( "Joy Rogers" ,  81774 ,  "Manufacturing", "Engineer");

        // System.out.println(emp_1.getName());
        // System.out.println(emp_1.getIdnumber());
        // System.out.println(emp_1.getDepartment());
        // System.out.println(emp_1.getPosition());

        // System.out.println(emp_2.getName());
        // System.out.println(emp_2.getIdnumber());
        // System.out.println(emp_2.getDepartment());
        // System.out.println(emp_2.getPosition());

        // System.out.println(emp_3.getName());
        // System.out.println(emp_3.getIdnumber());
        // System.out.println(emp_3.getDepartment());
        // System.out.println(emp_3.getPosition());

        System.out.println(emp_1.toString());
        System.out.println(emp_2.toString());
        System.out.println(emp_3.toString());
    }



}
