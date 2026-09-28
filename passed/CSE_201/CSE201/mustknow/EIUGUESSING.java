import java.util.*;

public class EIUGUESSING {
    public static void main(String[] args) throws Exception {
      Scanner sc = new Scanner(System.in);
      StringBuilder sb = new StringBuilder();
      
      long low = sc.nextLong();
      long high = sc.nextLong();
      
      long mid =0;
      

      while(high - low >= 0){
        mid = (low + high)/2;
        System.out.println(mid);
        System.out.flush();

        String response = sc.next();

        if (response.equals("LOW")){
            low = mid + 1;
        }
        if(response.equals("HIGH")){
            high = mid- 1;
        }
        if(response.equals("WIN")){
            break;
        }
      }
    }
}
