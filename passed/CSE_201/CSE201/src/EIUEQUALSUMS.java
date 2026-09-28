import java.util.HashMap;
import java.util.Scanner;

public class EIUEQUALSUMS {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        int n = sc.nextInt();

        long s = sc.nextLong();

        HashMap<Long , Integer> prefix = new HashMap<>();

        prefix.put(0L, 1);


        long num = 0; 
        long sum =0;
        int count =0;

        for ( int i =0 ;  i < n ; i++){
            num = sc.nextLong();
            sum += num;
            long target = sum - s;
            if( prefix.containsKey(target)){
                count += prefix.get(target);
            }
            prefix.put(sum, prefix.getOrDefault(sum, 0)+1);
        }
        System.out.println(count);
    }    
}
