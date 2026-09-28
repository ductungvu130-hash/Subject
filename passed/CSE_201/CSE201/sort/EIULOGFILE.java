import java.util.*;

public class EIULOGFILE {

    
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        
        String nStr = sc.next();
        if (nStr == null) return;
        
        int n = Integer.parseInt(nStr);
        long[] a = new long[n];
        
        for (int i = 0; i < n; i++) {
            a[i] = sc.nextLong();
        }
        
        Arrays.sort(a);
        
        long totalTime = 0;
        int left = 0;
        
        for (int right = 0; right < n; right++) {
            while (a[right] - a[left] > 600000L) {
                left++;
            }
            totalTime += (right - left);
        }
        
        System.out.println(totalTime);
    }
}