package problem3;

import java.util.*;

class Employee {

    private String id;
    private String name;

    public Employee(String id, String name) {
        this.id = id;
        this.name = name;
    }

    @Override
    public String toString() {
        return "Employee Name: " + name + " || ID: " + id;
    }

    public String getId() {
        return id;
    }
}

class EmployeeMap {

    private Map<String, Employee> employees = new HashMap<>();

    public void addEmployee(Employee emp, String id) {
        employees.put(id, emp);
    }

    public Employee lookupEmployee(String id) {
        return employees.get(id);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("Information:\n");
        for (Employee emp : employees.values()) {
            sb.append(emp.toString()).append("\n");
        }
        return sb.toString().trim();
    }

}
