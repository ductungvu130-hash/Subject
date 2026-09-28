import java.util.*;

public class EIPAIR {
    public static void main(String[] args) throws Exception {
        Scanner sc = new Scanner(System.in);
        StringBuilder sb = new StringBuilder();

        int n = sc.nextInt();
       
        for(int i =0 ; i < n ; i++ ){
            int way =0;
            int k =  sc.nextInt();
            int [] price = new int [k];
            for(int a=0 ; a < k ; a++){
                price[a] = sc.nextInt();
            }

            Arrays.sort(price);
            

            for(int b = 0 ; b < k; b++ ){
                for(int c = 1 ; b+ c < k; c++){
                if(price[b] == price[b+c]){
                    way++;
                }
              }
            }
             System.out.println(way);
        }
       

    }
}
