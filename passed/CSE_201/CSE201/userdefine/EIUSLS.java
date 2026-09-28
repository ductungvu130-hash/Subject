import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class EIUSLS {

    static class Student {
        String name;
        int originalIndex;
        double totalScore;
        int courseCount;

        public Student(String name, int originalIndex) {
            this.name = name;
            this.originalIndex = originalIndex;
            this.totalScore = 0.0;
            this.courseCount = 0;
        }

        public void addScore(double score) {
            this.totalScore += score;
            this.courseCount++;
        }

        public double getAverage() {
            if (this.courseCount == 0) {
                return 0.0;
            }
            return this.totalScore / this.courseCount;
        }
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        
        if (!sc.hasNextInt()) return;
        int n = sc.nextInt();
        
        List<Student> list = new ArrayList<>();

        for (int i = 0; i < n; i++) {
            String name = sc.next();
            Student student = new Student(name, i);
            
            int m = sc.nextInt();
            for (int j = 0; j < m; j++) {
                student.addScore(sc.nextDouble()); 
            }
            
            list.add(student);
        }

        list.sort((a, b) -> {
            int scoreCompare = Double.compare(b.getAverage(), a.getAverage());
            
            if (scoreCompare == 0) {
                return Integer.compare(a.originalIndex, b.originalIndex);
            }
            return scoreCompare;
        });

        for (int i = 0; i < 2 && i < list.size(); i++) {
            System.out.println(list.get(i).name);
        }
    }
}