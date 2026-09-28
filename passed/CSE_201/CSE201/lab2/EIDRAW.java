import java.util.Arrays;
import java.util.Scanner;

public class EIDRAW {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        if (sc.hasNextInt()) {
            int h = sc.nextInt();
            int width = 4 * h;

            for (int i = 0; i < h; i++) {
                char[] row = new char[width];
                Arrays.fill(row, ' ');

                row[i] = '\\';
                row[2 * h - 1 - i] = '/';
                row[2 * h + i] = '\\';
                row[4 * h - 1 - i] = '/';

                System.out.println(new String(row));
            }
        }
        sc.close();
    }
}
