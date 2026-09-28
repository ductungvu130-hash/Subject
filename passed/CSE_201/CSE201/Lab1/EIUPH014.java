import java.util.Scanner;

public class EIUPH014 {

    public static boolean checkEqual(int[] arr) {
        if (arr.length == 0) return true;
        int firstVal = arr[0];
        for (int i = 1; i < arr.length; i++) {
            if (arr[i] != firstVal) {
                return false;
            }
        }
        return true;
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        while (true) {
            int n = sc.nextInt();
            int[] arr = new int[n];
            for (int i = 0; i < n; i++) {
                arr[i] = sc.nextInt();
            }

            int count = 0;
            boolean found = false;

            
            while (count <= 1000) {
               
                if (checkEqual(arr)) {
                    System.out.println(count);
                    found = true;
                    break;
                }
                
                
                if (count == 1000) {
                    break;
                }

        
                int[] nextArr = new int[n];
                
               
                for (int i = 0; i < n - 1; i++) {
                    nextArr[i] = Math.abs(arr[i] - arr[i+1]);
                }
                
               
                nextArr[n - 1] = Math.abs(arr[n - 1] - arr[0]);

                
                arr = nextArr;
                count++;
            }

            if (!found) {
                System.out.println("-1");
            }
        }
        
        
    }
}