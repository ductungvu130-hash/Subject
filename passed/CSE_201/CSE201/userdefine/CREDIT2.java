import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class CREDIT2 {

    static class Student {

        private String name;
        private int passCount;
        private int totalScore;
        private List<Integer> passedScores;

        public Student(String name) {
            this.name = name;
            this.passedScores = new ArrayList<>();
            this.passCount = 0;
            this.totalScore = 0;
        }

        public void addScore(int score) {
            if (score >= 50) {
                passedScores.add(score);
                this.totalScore += score;
                this.passCount++;
            }
        }

        public void appendTo(StringBuilder sb) {
            sb.append(this.name);

            if (passCount == 0) {
                sb.append(" 0\n");
            } else {
                for (int score : passedScores) {
                    sb.append(" ").append(score);
                }
                
                long average =  this.totalScore / this.passCount;
                sb.append(" ").append(average).append("\n");
            }
        }
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);


        int n = scanner.nextInt();
        
        StringBuilder resultBuilder = new StringBuilder();

        for (int i = 0; i < n; i++) {
            String name = scanner.next();
            int c = scanner.nextInt();

            Student student = new Student(name);

            for (int j = 0; j < c; j++) {
                int score = scanner.nextInt();
                student.addScore(score);
            }

            student.appendTo(resultBuilder);
        }

        System.out.print(resultBuilder.toString());

        
    }
}