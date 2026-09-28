package problem0;


public class Employee {
    private String name;
    private int idnumber;
    private String department;
    private String position;

    public Employee(String name, int idnumber, String department, String position) {
        this.name = name;
        this.idnumber = idnumber;
        this.department = department;
        this.position = position;
    }

    public Employee(String name, int idnumber) {
        this.name = name;
        this.idnumber = idnumber;
        this.department = "";
        this.position = "";
    }


    
    public Employee() {
        this.name = "";
        this.idnumber = 0;
        this.department = "";
        this.position = "";
    }

    public void setName(String name) {
        this.name = name;
    }
    
    public void setIdnumber(int idnumber) {
        this.idnumber = idnumber;
    } 
  

    public void setDepartment(String department) {
        this.department = department;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getName() {
        return name;
    }

    public int getIdnumber() {
        return idnumber;
    }

    public String getDepartment() {
        return department;
    }

    public String getPosition() {
        return position;
    }

   
    @Override
    public String toString() {
        return "Name: " + getName() + ", Idnumber: " + getIdnumber() + ", Department: "
                + getDepartment() + ", Position: " + getPosition();
    }

    

}


    