import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

public class EIUGRADE {

    static class Student {
        int id;
        double totalScore;
        int courseCount;
        double avgScore;

        public Student(int id) {
            this.id = id;
            this.totalScore = 0.0;
            this.courseCount = 0;
        }

        public void addScore(double score) {
            this.totalScore += score;
            this.courseCount++;
        }

        public void calculateAverage() {
            this.avgScore = this.totalScore / this.courseCount;
        }
        
        public double getRoundedAverage() {
            return Math.round(this.avgScore * 1000.0) / 1000.0;
        }
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        
        if (!sc.hasNextInt()) return;
        
        int n = sc.nextInt();
        
        Map<Integer, Student> map = new HashMap<>();

        for (int i = 0; i < n; i++) {
            int studentId = sc.nextInt();
            int courseId = sc.nextInt(); 
            double score = sc.nextDouble();

            if (!map.containsKey(studentId)) {
                map.put(studentId, new Student(studentId));
            }
            
            map.get(studentId).addScore(score);
        }

        List<Student> list = new ArrayList<>(map.values());

        for (Student s : list) {
            s.calculateAverage();
        }

        list.sort((a, b) -> {
            int scoreCompare = Double.compare(b.avgScore, a.avgScore);
            
            if (scoreCompare == 0) {
                return Integer.compare(a.id, b.id);
            }
            return scoreCompare; 
        });

        StringBuilder sb = new StringBuilder();
        for (Student s : list) {
            sb.append(s.id).append(" ").append(s.getRoundedAverage()).append("\n");
        }
        
        System.out.print(sb.toString());
    }
}