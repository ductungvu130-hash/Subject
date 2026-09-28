import java.util.Arrays;
import java.util.Scanner;

public class EIUAVERAGE {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;

       
        int n = sc.nextInt();
        long[] a = new long[n];
        for (int i = 0; i < n; i++) {
            a[i] = sc.nextLong();
        }
        
        Arrays.sort(a);
        
        long[] S = new long[n + 1];
        for (int i = 1; i <= n; i++) {
            S[i] = S[i - 1] + a[i - 1];
        }
        
        
        int q = sc.nextInt();
        StringBuilder sb = new StringBuilder(); 
        
        
        for (int i = 0; i < q; i++) {
            long k = sc.nextLong();
            
            int low = 1;
            int high = n;
            int ans = 0; 
            
            while (low <= high) {
                int mid = (int) (high + low) / 2; 
                
                
                if (S[mid] < (long) mid * k) {
                    ans = mid;        
                    low = mid + 1;    
                } else {
                    high = mid - 1;   
                }
            }
            
            
            sb.append(ans).append("\n");
        }
        
      
        System.out.print(sb.toString());
    }
}