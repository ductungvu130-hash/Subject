
import java.util.Scanner;
import java.util.Stack;

public class EIMAXWIDTH {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        int n = sc.nextInt();
        int[] a = new int[n];
        for (int i = 0; i < n; i++) {
            a[i] = sc.nextInt();
        }

        Stack<Integer> stack = new Stack<>();

        for (int i = 0; i < n; i++) {
            if (stack.isEmpty() || a[stack.peek()] > a[i]) {
                stack.push(i);
            }
        }

        int max = 0;

        for (int i = n - 1; i >= 0; i--) {
            int length = 0;
            while (!stack.isEmpty() && a[stack.peek()] <= a[i]) {
                length = i - stack.pop();

                if (length > max) {
                    max = length;
                }
            }
        }
        System.out.println(max);
    }
}
