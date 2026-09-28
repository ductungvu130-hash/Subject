import java.util.*;

public class EIULOGFILE2 {

   

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        
        String nStr = sc.next();
        if (nStr == null) return;
        
        int n = Integer.parseInt(nStr);
        int m = sc.nextInt();
        
        long[] a = new long[n];
        for (int i = 0; i < n; i++) {
            a[i] = sc.nextLong();
        }
        
        Arrays.sort(a);
        
        StringBuilder sb = new StringBuilder();
        
        for (int i = 0; i < m; i++) {
            long e = sc.nextLong();
            
            int low = 0, high = n - 1;
            long ans = -1;
            
            while (low <= high) {
                int mid = low + (high - low) / 2;
                if (a[mid] >= e) {
                    ans = a[mid];
                    high = mid - 1; 
                } else {
                    low = mid + 1;
                }
            }
            
            sb.append(ans).append(" ");
        }
        
        System.out.println(sb.toString().trim());
    }
}