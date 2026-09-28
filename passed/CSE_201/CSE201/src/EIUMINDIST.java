import java.util.*;

public class EIUMINDIST {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        
        String nStr = sc.next();
        if (nStr == null) return;
        
        int n = Integer.parseInt(nStr);
        int k = sc.nextInt();
        
        int[] a = new int[n];
        for (int i = 0; i < n; i++) {
            a[i] = sc.nextInt();
        }
        
        Arrays.sort(a);
        
        int low = 0;
        int high = a[n - 1] - a[0];
        int ans = 0;
        
        while (low <= high) {
            int mid = low + (high - low) / 2;
            
            if (canPlace(a, n, k, mid)) {
                ans = mid;
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
        
        System.out.println(ans);
    }
    
    static boolean canPlace(int[] a, int n, int k, int mid) {
        int count = 1;
        int lastPlaced = a[0];
        
        for (int i = 1; i < n; i++) {
            if (a[i] - lastPlaced >= mid) {
                count++;
                lastPlaced = a[i];
                if (count == k) return true;
            }
        }
        return false;
    }
}