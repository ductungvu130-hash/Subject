import java.util.*;

public class EIUGIFTS {
    public static void main(String[] args) throws Exception {
        Scanner sc = new Scanner(System.in);
        StringBuilder sb = new StringBuilder();
        
        int n = sc.nextInt();
        int money = sc.nextInt();
        
        int [] arr = new int [n];

        for( int i =0 ; i < n; i ++){
            arr[i] =sc.nextInt();
        }

        Arrays.sort(arr);

        int k = n -1;
        int i=0;
        int diff =0;
        long mindiff = Long.MAX_VALUE;
        long total = Long.MIN_VALUE;
        
        if(arr[i] + arr[i+1] > money){
            System.out.println("-1 -1");
            return;
        }

        while ( i < k){
            int sum = arr[k] + arr[i];
            if(sum <= money){
                diff = arr[k] - arr[i];
                if (sum > total) {
                    total = sum;
                    mindiff = diff;
                } 
                
                else if (sum == total) {
                    if ( diff < mindiff) {
                        mindiff = diff;
                    }
                }
                i++;

            }else{
                k--;
            }
        }

        System.out.println(total + " " + mindiff);
    }
}

