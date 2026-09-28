import java.util.*;

public class EISWMED1 {
    public static void main(String[] args) throws Exception {
        Scanner sc = new Scanner(System.in);
        StringBuilder sb = new StringBuilder();

        String s = sc.next();
        int k = sc.nextInt();
        int currentW = 0;

        for(int i = 0 ; i< k ; i++){
            if (s.charAt(i) == 'W' ){
                currentW++;
            }
        }

        int lastcurrent = currentW;

        for ( int i = k ; i < s.length() ; i++){
            if(s.charAt(i) == 'W'){
                currentW++;
            }
            if(s.charAt(i-k) == 'W'){
                currentW--;
            }
            if(currentW < lastcurrent){
                lastcurrent = currentW;
            }
        }
        System.out.println(lastcurrent);
      
    }
}
