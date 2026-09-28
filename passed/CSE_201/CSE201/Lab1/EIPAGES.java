import java.util.Arrays;
import java.util.Scanner;

public class EIPAGES {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
                
            int n = sc.nextInt();
            int[] pages = new int[n];
            for (int i = 0; i < n; i++) {
                pages[i] = sc.nextInt();
            }
            
            Arrays.sort(pages);
            
            StringBuilder sb = new StringBuilder();
            
            int i = 0;
            while (i < n) {
                int start = i;
                while (i < n - 1 && pages[i + 1] == pages[i] + 1) {
                    i++;
                }
                int end = i;
                
                int length = end - start + 1;
                
                if (length >= 3) {
                    sb.append(pages[start]).append("-").append(pages[end]).append(" ");
                } else {
                    for (int j = start; j <= end; j++) {
                        sb.append(pages[j]).append(" ");
                    }
                }
                
                i++;
            }
            
            System.out.println(sb.toString().trim());
        
        sc.close();
    }
}
