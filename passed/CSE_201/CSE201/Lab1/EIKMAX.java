import java.util.*;

public class EIKMAX {
    public static void main(String[] args) throws Exception {
      Scanner sc = new Scanner(System.in);
      StringBuilder sb = new StringBuilder();
      int n = sc.nextInt();
      int k = sc.nextInt();
      long []arr = new long[n];
      for (int i =0 ; i < n ; i++){
            arr[i] =sc.nextLong();
      }
      
      Arrays.sort(arr);
            
      for(int i=0 ; i < k; i++){
        sb.append(arr[n- 1 - i]) . append(" ");
      }

      System.out.println(sb.toString());
    }
}
