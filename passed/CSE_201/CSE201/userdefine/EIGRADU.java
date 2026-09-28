
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class EIGRADU {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        StringBuilder sb = new StringBuilder();

        int n = sc.nextInt();
        int credit = sc.nextInt();
        

        List <Student> list = new ArrayList<>();

        for ( int i =0 ; i < n ; i++){

            long studentId = sc.nextLong();
            String name = sc.next();
            Student stu = new Student(name, studentId);

            int k = sc.nextInt();
            for(int j = 0 ; j < k ; j++ ){
                int score = sc.nextInt();
                stu.addScore(score);

            }         
            list.add(stu);
        }
       
        for(Student stu : list){
            stu.calavg();
        }

        list.sort((a,b) -> {
            int index = Double.compare(b.avg, a.avg);

            if (index == 0 ){
                return Long.compare(a.id, b.id);
            }
                return index;  
        });

       for(Student stu : list){
        if(stu.totalCredit >= credit){
            sb.append(stu.id).append(" ").append(stu.name).append(" ").append(stu.avg).append("\n");
        }
       } 
       System.out.println(sb.toString());
    }

    static class Student {

        private String name;
        private long id;
        private int pass;
        private int total;
        private int avg;
        private int totalCredit ;

        public Student(String name, long id) {
            this.name = name;
            this.id = id;
            this.pass = 0;
            this.total = 0;
            this.totalCredit =0;
            
        }

        public void addScore(double score) {  
            if(score >= 50) {
                this.totalCredit+=4;
                this.total += score;
                this.pass++;
            }
        }

        public void calavg(){
            this.avg = Math.round(this.total /this.pass);
        }

        
    }
}
