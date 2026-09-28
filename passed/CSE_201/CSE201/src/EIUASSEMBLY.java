import java.util.*;

public class EIUASSEMBLY {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        
        String tStr = sc.next();
        if (tStr == null) return;
        int t = Integer.parseInt(tStr);
        
        StringBuilder sb = new StringBuilder();

        while (t-- > 0) {
            int n = sc.nextInt();
            long m = sc.nextLong();

            long[] p = new long[n];
            long[] cost = new long[n];

            long minP = Long.MAX_VALUE;
            long maxP = 0;
            
            for (int i = 0; i < n; i++) {
                p[i] = sc.nextLong();
                cost[i] = sc.nextLong();
                if (p[i] > maxP) {
                    maxP = p[i];
                }
                if (p[i] < minP) {
                    minP = p[i];
                }
            }

            long low = minP;
            long high = maxP + m; 
            long ans = minP;

            while (low <= high) {
                long mid = low + (high - low) / 2;

                if (canAchieve(mid, m, n, p, cost)) {
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

    static boolean canAchieve(long target, long m, int n, long[] p, long[] cost) {
        long totalCost = 0;
        for (int i = 0; i < n; i++) {
            if (p[i] < target) {
                long diff = target - p[i];
                
                if (cost[i] > 0 && diff > (m - totalCost) / cost[i]) {
                    return false;
                }
                
                totalCost += diff * cost[i];
                
                if (totalCost > m) {
                    return false;
                }
            }
        }
        return true;
    }
}