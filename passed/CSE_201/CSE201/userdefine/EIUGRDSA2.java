import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

public class EIUGRDSA2 {

    static class Student {
        int id;
        int[] maxScores;
        int count;
        long avg; 

        public Student(int id, int p) {
            this.id = id;
            this.maxScores = new int[p];
            Arrays.fill(this.maxScores, Integer.MIN_VALUE);
            this.count = 0;
        }

        public void addScore(int pIndex, int score) {
            this.count++; 
            if (score > this.maxScores[pIndex]) {
                this.maxScores[pIndex] = score;
            }
        }

        public void calcAverage(int p) {
            if (p == 0) {
                this.avg = 0;
                return;
            }
            long total = 0;
            for (int i = 0; i < p; i++) {
                if (this.maxScores[i] != Integer.MIN_VALUE) {
                    total += this.maxScores[i];
                }
            }
            this.avg = Math.floorDiv(total, p);
        }
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;

        int n = sc.nextInt();
        int p = sc.nextInt();
        int m = sc.nextInt();

        Map<Integer, Student> map = new HashMap<>();
        for (int i = 0; i < n; i++) {
            int studentId = sc.nextInt();
            if (!map.containsKey(studentId)) {
                map.put(studentId, new Student(studentId, p));
            }
        }

        Map<Integer, Integer> problem = new HashMap<>();
        for (int i = 0; i < p; i++) {
            int subject = sc.nextInt();
            problem.put(subject, i);
        }

        for (int i = 0; i < m; i++) {
            int stuId = sc.nextInt();
            int subID = sc.nextInt();
            int subScore = sc.nextInt();

            Student stu1 = map.get(stuId);
            Integer pIndex = problem.get(subID);

            if (stu1 != null && pIndex != null) {
                stu1.addScore(pIndex, subScore);
            }
        }

        List<Student> list = new ArrayList<>(map.values());

        for (Student s : list) {
            s.calcAverage(p);
        }

        list.sort((a, b) -> {
            int scoreCompare = Long.compare(b.avg, a.avg);
            
            if (scoreCompare == 0) {
                int countCompare = Integer.compare(a.count, b.count);
                if (countCompare == 0) {
                    return Integer.compare(a.id, b.id);
                }
                return countCompare;
            }
            return scoreCompare;
        });

        StringBuilder sb = new StringBuilder();
        for (Student s : list) {
            sb.append(s.id).append(" ").append(s.avg).append(" ").append(s.count).append("\n");
        }
        
        System.out.print(sb.toString());
    }
}