import java.util.*;

public class EIPICNIC {
    public static void main(String[] args) throws Exception {
       Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();

        int[] arr = new int[n];
        for (int i = 0; i < n; i++) {
            arr[i] = sc.nextInt();
        }

        int a1 = 0, a2 = 0, a3 = 0, a4 = 0;

        for (int x : arr) {
            if (x == 1) a1++;
            else if (x == 2) a2++;
            else if (x == 3) a3++;
            else a4++;
        }

        int car = a4;

        
        int com = Math.min(a1, a3);
        car += a3;
        a1 -= com;

        
        car += a2 / 2;
        if (a2 % 2 == 1) {
            car++;
            a1 -= Math.min(2, a1);
        }

        
        if (a1 > 0) {
            car += (a1 + 3) / 4;
        }

        System.out.println(car);
    }
}
