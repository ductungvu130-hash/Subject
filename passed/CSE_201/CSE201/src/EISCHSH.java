import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class EISCHSH {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        StringBuilder sb = new StringBuilder();

        int n = sc.nextInt();
        int k = sc.nextInt();
        

        List <Student> list = new ArrayList<>();

        for ( int i =0 ; i < n ; i++){

            long studentId = sc.nextLong();
            String name = sc.next();
            Student stu = new Student(name, studentId);

            int z = sc.nextInt();
            for(int j = 0 ; j < z ; j++ ){
                int score = sc.nextInt();
                stu.addScore(score);

            } 
            stu.calavg();        
            list.add(stu);
        }
       
        

        list.sort((a,b) -> {
            int index = Double.compare(b.avg, a.avg);

            if (index == 0 ){
                return Long.compare(a.id, b.id);
            }
                return index;  
        });

        int rank =1;
       for(int i = 0; i < list.size() ;i++){
        Student stu = list.get(i);

        if( i > 0 && stu.avg < list.get(i-1).avg){
            rank = i+1;
        }
        if(rank > k){
            break;
        }
        sb.append(rank).append(" ").append(stu.id).append(" ").append(stu.name).append(" ").append(stu.rounded).append("\n");
       } 
       System.out.println(sb.toString());
    }

    static class Student {

        private String name;
        private long id;
        private int pass;
        private int total;
        private double avg;
        private int rounded;
        

        public Student(String name, long id) {
            this.name = name;
            this.id = id;
            this.pass = 0;
            this.total = 0;
        }

        public void addScore(double score) {  
            if(score >= 50) {
                this.total += score;
                this.pass++;
            }
        }

        public void calavg(){
            this.avg = (double)this.total /this.pass;
            this.rounded = (int)Math.round(this.avg);
        }

        
    }
}
