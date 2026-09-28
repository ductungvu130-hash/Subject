package problem1_2_3;

import java.time.LocalDate;

public class Employee {

    private String name;
    private String number;
    private LocalDate hireDate;

   

    public Employee(String name, String number, LocalDate hireDate) {
        this.name = name;
        this.number = number;
        this.hireDate = hireDate;
    
    }





    private boolean validate() {
        char [] c = this.number.toCharArray();

        if (number.length() != 5){
            return false;
        } 
        
        if(c[3] != '-') {
            return false;
        }

        for(int i =0 ; i < 3; i++){
            if(!Character.isDigit(c[i])){
                return false;
            }
        }
        
        if ( c[4] >= 'A' && c[4] <= 'M'){ 
            return true;
        }else{
            return false;
        }
            
    }





    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public LocalDate getHireDate() {
        return hireDate;
    }


    public void setHireDate(LocalDate hireDate) {
        this.hireDate = hireDate;
    }
    

    public void checknumber(){
    if (!validate()){
      System.out.println("Wrong emoloyee number");
    } 
    else{
        System.err.println("Correct employee number");
    }
    }
    





    @Override
    public String toString() {
        return "Employee Name: " + getName() + ", Number: " + getNumber() + ", Hire Date: " + getHireDate()
                ;
    }
    
    
}
