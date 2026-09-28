import java.util.Scanner;


class Student {
    private String id;
    private int totalCredits;

    public Student(String id) {
        this.id = id;
        this.totalCredits = 0; 
    }

    
    public void addScore(int score) {
        if (score >= 50) {
            this.totalCredits += 4; 
        }
    }

    
    public String getId() {
        return id;
    }

    
    public int getTotalCredits() {
        return totalCredits;
    }
}

public class EICREDIT {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        
        int n = sc.nextInt();
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < n; i++) {
            String studentId = sc.next();
            
            Student student = new Student(studentId);
            
            int c = sc.nextInt();
            
            
            for (int j = 0; j < c; j++) {
                int score = sc.nextInt();
                student.addScore(score);
            }
            
            sb.append(student.getId()).append(" ").append(student.getTotalCredits()).append("\n");
        }

        System.out.print(sb.toString());
    }
}