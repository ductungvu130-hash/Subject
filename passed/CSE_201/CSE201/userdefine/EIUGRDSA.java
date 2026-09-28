import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

public class EIUGRDSA {

    static class Student {
        int id;
        int[] maxScores;

        public Student(int id, int p) {
            this.id = id;
            this.maxScores = new int[p];
            Arrays.fill(this.maxScores, -1);
        }

        public void updateScore(int pIndex, int score) {
            if (score > this.maxScores[pIndex]) {
                this.maxScores[pIndex] = score;
            }
        }

        public long getAverage(int p) {
            if (p == 0) return 0;
            long total = 0;
            for (int score : this.maxScores) {
                if (score != -1) {
                    total += score;
                }
            }
            return Math.floorDiv(total, p);
        }
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;

        int n = sc.nextInt();
        int p = sc.nextInt();
        int m = sc.nextInt();

        Map<Integer, Student> studentMap = new HashMap<>();
        List<Student> students = new ArrayList<>();

        for (int i = 0; i < n; i++) {
            int id = sc.nextInt();
            Student st = new Student(id, p);
            studentMap.put(id, st);
            students.add(st);
        }

        Map<Integer, Integer> problemMap = new HashMap<>();
        for (int i = 0; i < p; i++) {
            problemMap.put(sc.nextInt(), i);
        }

        for (int i = 0; i < m; i++) {
            int studentId = sc.nextInt();
            int problemId = sc.nextInt();
            int score = sc.nextInt();

            Student st = studentMap.get(studentId);
            Integer pIndex = problemMap.get(problemId);

            if (st != null && pIndex != null) {
                st.updateScore(pIndex, score);
            }
        }

        students.sort(Comparator.comparingInt(s -> s.id));

        StringBuilder sb = new StringBuilder();
        for (Student st : students) {
            sb.append(st.id).append(" ").append(st.getAverage(p)).append("\n");
        }
        
        System.out.print(sb.toString());
    }
}