import java.util.Scanner;
import java.util.Stack;

public class EIMONOSTACK {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNext()) return;

        int m = sc.nextInt();
        int n = sc.nextInt();

        int[] A = new int[m];
        for (int i = 0; i < m; i++) {
            A[i] = sc.nextInt();
        }

        int[] B = new int[n];
        for (int i = 0; i < n; i++) {
            B[i] = sc.nextInt();
        }

        int[] lookup = new int[1000001];
        Stack<Integer> stack = new Stack<>();

        for (int num : B) {
            while (!stack.isEmpty() && stack.peek() < num) {
                lookup[stack.pop()] = num;
            }
            stack.push(num);
        }

        StringBuilder sb = new StringBuilder();
        for (int val : A) {
            int res = lookup[val];
            if (res == 0) {
                sb.append("-1 ");
            } else {
                sb.append(res).append(" ");
            }
        }
        System.out.println(sb.toString().trim());
    }
}