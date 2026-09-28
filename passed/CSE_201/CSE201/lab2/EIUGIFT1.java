import java.util.*;

public class EIUGIFT1 {
    public static void main(String[] args) throws Exception {
        Scanner sc = new Scanner(System.in);
        StringBuilder sb = new StringBuilder();
        int n = sc.nextInt();
        int m = sc.nextInt();

        int [] a = new int [n];
        int [] b = new int [m];

        for(int i = 0 ; i< n ; i++){
            a[i] = sc.nextInt();
        }
        
        for(int i = 0 ; i< m ; i++){
            b[i] = sc.nextInt();
        }

        Arrays.sort(a);
        Arrays.sort(b);
        int count =0 ;
        int k = 0;
        int i =0;

        while ( i < n && k <m){        
            if ( b[k] < 2*a[i]){
                    k++;
            }
            else if ( b[k] > 3*a[i]){
                    i++;
            }
            else{
                i++;
                k++;
                count++;
            }

            }
        System.out.println(count);
    }
}