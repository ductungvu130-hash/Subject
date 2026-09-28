
import java.util.Scanner;

public class EIWEAKCHAR {
    public static void main(String[] args)  {
        Scanner sc = new Scanner(System.in);
        
        int n = sc.nextInt();
                
        int[] A = new int[n];
        int[] D = new int[n];
        int maxAttack = 0;
        
        // Pass 1: Read input and find the global maximum attack value
        for (int i = 0; i < n; i++) {
            A[i] = sc.nextInt();
            D[i] = sc.nextInt();
            if (A[i] > maxAttack) {
                maxAttack = A[i];
            }
        }
        
        // Array to store the maximum defense for any given attack value.
        // Size is maxAttack + 2 to safely handle the (A[i] + 1) lookup later.
        int[] maxDef = new int[maxAttack + 2];
        
        // Pass 2: Record the highest defense for each specific attack value
        for (int i = 0; i < n; i++) {
            if (D[i] > maxDef[A[i]]) {
                maxDef[A[i]] = D[i];
            }
        }
        
        // Pass 3: Sweep right-to-left so maxDef[i] becomes the max defense 
        // for any attack >= i
        for (int i = maxAttack; i >= 0; i--) {
            if (maxDef[i + 1] > maxDef[i]) {
                maxDef[i] = maxDef[i + 1];
            }
        }
        
        // Pass 4: Count the weak characters
        int weakCount = 0;
        for (int i = 0; i < n; i++) {
            // If current defense is less than the max defense of any character
            // with strictly greater attack, this character is weak.
            if (D[i] < maxDef[A[i] + 1]) {
                weakCount++;
            }
        }
        
        System.out.println(weakCount);
    }

}