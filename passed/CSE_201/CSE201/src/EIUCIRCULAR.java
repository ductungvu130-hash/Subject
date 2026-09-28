import java.util.Scanner;

public class EIUCIRCULAR {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (!sc.hasNextInt()) return;

        int q = sc.nextInt();
        StringBuilder sb = new StringBuilder();

        while (q-- > 0) {
            int n = sc.nextInt();
            int[] a = new int[n];
            for (int i = 0; i < n; i++) {
                a[i] = sc.nextInt();
            }

            if (hasCycle(a, n)) {
                sb.append("YES\n");
            } else {
                sb.append("NO\n");
            }
        }

        System.out.print(sb.toString());
        sc.close();
    }

    static boolean hasCycle(int[] a, int n) {
        int[] color = new int[n];

        for (int i = 0; i < n; i++) {
            if (color[i] != 0) continue;

            int curr = i;
            while (color[curr] == 0) {
                color[curr] = 1;
                int next = getNext(curr, a, n);

                if (!isSameDir(a[curr], a[next])) {
                    break;
                }

                if (color[next] == 1) {
                    if (next != curr) {
                        return true;
                    }
                    break;
                }
                curr = next;
            }

            curr = i;
            while (color[curr] == 1) {
                color[curr] = 2;
                int next = getNext(curr, a, n);
                if (!isSameDir(a[curr], a[next])) {
                    break;
                }
                curr = next;
            }
        }
        return false;
    }

    static int getNext(int i, int[] a, int n) {
        return (int) (((i + (long) a[i]) % n + n) % n);
    }

    static boolean isSameDir(int x, int y) {
        return (x > 0 && y > 0) || (x < 0 && y < 0);
    }
}