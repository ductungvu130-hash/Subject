import java.lang.*;
import java.util.*;

class Student {
    int id;
    double totalScore;
    int count;

    public Student(int id) {
        this.id = id;
        this.totalScore = 0;
        this.count = 0;
    }

    public double getAverage() {
        return totalScore / count;
    }
}

public class EIUGRADE {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;
        
        int n = sc.nextInt();
        Map<Integer, Student> map = new HashMap<>();

        for (int i = 0; i < n; i++) {
            int mssv = sc.nextInt();
            int maMon = sc.nextInt(); 
            double diem = sc.nextDouble();

            map.putIfAbsent(mssv, new Student(mssv));
            Student s = map.get(mssv);
            s.totalScore += diem;
            s.count++;
        }

        List<Student> list = new ArrayList<>(map.values());

        
        list.sort((s1, s2) -> {
            double avg1 = s1.getAverage();
            double avg2 = s2.getAverage();
            if (Math.abs(avg1 - avg2) < 0.000001) {
                return Integer.compare(s1.id, s2.id); 
            }
            return Double.compare(avg2, avg1); 
        });

        
        StringBuilder sb = new StringBuilder();
        for (Student s : list) {
            sb.append(s.id).append(" ").append(String.format("%.2f", s.getAverage())).append("\n");
        }
        System.out.print(sb);
    }
}

