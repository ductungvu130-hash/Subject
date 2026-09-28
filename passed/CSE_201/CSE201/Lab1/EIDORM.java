import java.util.Scanner;

public class EIDORM {
    public static void main(String[] args) throws Exception {
      Scanner sc = new Scanner(System.in);
      int n = sc.nextInt();
      int count =0;
      for (int i =0; i < n ; i++){
        int people = sc.nextInt();
        int maxpeople = sc.nextInt();
        if (maxpeople - people >= 2){
            count++;
        }
      }
      System.out.println(count);
    }
}

