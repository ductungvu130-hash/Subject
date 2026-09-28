import java.util.*;

public class EIUPH010 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        int N = sc.nextInt();
        int[] cnt = new int[1_000_000];

        for (int i = 0; i < N; i++) {
            int x = sc.nextInt();
            cnt[x]++;
        }

        int bestValue = 0;
        int maxFreq = 0;

        for (int i = 0; i < 1_000_000; i++) {
            if (cnt[i] > maxFreq) {
                maxFreq = cnt[i];
                bestValue = i;
            }
        }

        System.out.println(bestValue + " " + maxFreq);
    }
}
