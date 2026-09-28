package problem3;

public class Main {
    public static void main(String[] args) {
        Employee emp1 = new Employee("01201", "Tony");
        Employee emp2 = new Employee("01202", "Tung");

        EmployeeMap empMap =new EmployeeMap();

        empMap.addEmployee(emp1,emp1.getId());
        empMap.addEmployee(emp2, emp2.getId());

        System.out.println(empMap.toString());
        System.out.println("Looking information: "+ empMap.lookupEmployee("01202").toString());
    }

}
