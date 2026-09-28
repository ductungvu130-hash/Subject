import java.util.Arrays;
import java.util.Scanner;

public class EIPSEASY1 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNext()) return;

        int n = sc.nextInt();
        int k = sc.nextInt();

        int[] a = new int[n];
        for (int i = 0; i < n; i++) {
            a[i] = sc.nextInt();
        }

       
        int[] firstOccurrence = new int[k];
        
      
        Arrays.fill(firstOccurrence, -2);

       
        firstOccurrence[0] = -1;

        long currentSum = 0;
        int maxLen = 0;

        for (int i = 0; i < n; i++) {
            currentSum += a[i];

            int rem = (int) ((currentSum % k) + k) % k;

            if (firstOccurrence[rem] != -2) {
               
                int len = i - firstOccurrence[rem];
                if (len > maxLen) {
                    maxLen = len;
                }
            } else {
             
                firstOccurrence[rem] = i;
            }
        }

        System.out.println(maxLen);
    }
}