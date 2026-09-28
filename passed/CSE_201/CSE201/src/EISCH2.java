
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class EISCH2 {

    static class Student {

        String name;
        double gpa;

        public Student(String name, double gpa) {
            this.name = name;
            this.gpa = gpa;
        }
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        int n = sc.nextInt();
        List<Student> students = new ArrayList<>();

        for (int i = 0; i < n; i++) {
            String name = sc.next();
            int p = sc.nextInt();
            int sum = 0;
            for (int j = 0; j < p; j++) {
                sum += sc.nextInt();
            }
            double gpa = (double) sum / p;
            students.add(new Student(name, gpa));
        }

        students.sort((s1, s2) -> {
            if (s1.gpa != s2.gpa) {
                return Double.compare(s2.gpa, s1.gpa);
            }
            return s1.name.compareTo(s2.name);
        });

        double removeA = students.get(students.size() / 12).gpa;
        double removeB = students.get(students.size() / 3).gpa;
        double removeC = students.get(students.size() / 2).gpa;

        StringBuilder sb = new StringBuilder();

        for (Student student : students) {
            String scholarship = "";

            if (student.gpa > removeA) {
                scholarship = "A";
            } else if (student.gpa > removeB) {
                scholarship = "B";
            } else if (student.gpa > removeC) {
                scholarship = "C";
            }

            if (!scholarship.isEmpty()) {
                double roundedGpa = Math.round(student.gpa * 100.0) / 100.0;
                
                sb.append(student.name).append(" ");
                
                if (roundedGpa == (long) roundedGpa) {
                    sb.append((long) roundedGpa);
                } else {
                    sb.append(roundedGpa);
                }
                
                sb.append(" ").append(scholarship).append("\n");
            }
        }

        System.out.print(sb);
    }
}
