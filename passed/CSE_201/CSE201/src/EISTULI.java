import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class EISTULI {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;

        int n = sc.nextInt();
        int k = sc.nextInt();

        List<Student> list = new ArrayList<>();

        for (int i = 0; i < n; i++) {
            long studentId = sc.nextLong();
            String name = sc.next();
            Student stu = new Student(name, studentId, i);

            int z = sc.nextInt();
            for (int j = 0; j < z; j++) {
                int score = sc.nextInt();
                stu.addScore(score);
            }
            stu.calavg();
            list.add(stu);
        }

        
        list.sort((a, b) -> {
            int ind = Double.compare(b.avg, a.avg);
            if (ind == 0) {
                return Integer.compare(a.index, b.index);
            }
            return ind;
        });

        
        int printCount = Math.min(n, k); 


        if (printCount < n && Double.compare(list.get(printCount - 1).avg, list.get(printCount).avg) == 0) {
            double dropScore = list.get(printCount - 1).avg; 
            while (printCount > 0 && Double.compare(list.get(printCount - 1).avg, dropScore) == 0) {
                printCount--;
            }
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < printCount; i++) {
            Student stu = list.get(i);
          
            sb.append(stu.id).append(" ").append(stu.name).append(" ")
              .append(stu.rounded).append(" ").append(stu.credit).append("\n");
        }
        
        System.out.print(sb.toString());
    }

    static class Student {
        private String name;
        private long id;
        private int pass;
        private int total;
        private int credit;
        private double avg;
        private int index;
        private int rounded;

        public Student(String name, long id, int index) {
            this.name = name;
            this.index = index;
            this.id = id;
            this.pass = 0;
            this.total = 0;
            this.credit = 0;
        }

        public void addScore(int score) { 
            if (score >= 50) {
                this.credit += 4;
                this.total += score;
                this.pass++;
            }
        }

        public void calavg() {
            
            if (this.pass == 0) {
                this.avg = 0.0;
                this.rounded = 0;
            } else {
                this.avg = (double) this.total / this.pass;
                this.rounded = (int) Math.round(this.avg);
            }
        }
    }
}