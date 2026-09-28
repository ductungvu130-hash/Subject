import java.util.Scanner;

public class EIUSLIDING {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        int n = sc.nextInt();
        int T = sc.nextInt();

        int [] a = new int [n];

        for(int i =0 ; i < n ; i++){
            a[i] =sc.nextInt();
        }

        int leng =0;
        int maxleng = 0;

        for (int i  =0 ; i< n ; i++){
            if (a[i] > T){
                leng =0;
                continue;
            }

            if ( leng > 0){
                if( a[i-1] %2 != a[i] %2 ){
                    leng++;
                }
                else {
                    if(a[i] %2 == 0){
                        leng = 1;
                    } else{
                        leng =0;
                    }
                }
            }else{
                if(a[i] %2 == 0){
                    leng = 1;
                } 
            }

            if(leng > maxleng){
                maxleng = leng;
            }
        }
        System.out.println(maxleng);

    }    
}
