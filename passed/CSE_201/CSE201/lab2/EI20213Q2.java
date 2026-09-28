import java.util.*;

public class EI20213Q2 {
    public static void main(String[] args) throws Exception {
      Scanner sc = new Scanner(System.in);
      StringBuilder sb = new StringBuilder();
      
      int n = sc.nextInt();
      int [] arr = new int [n];

      for(int i =0 ; i  < n ; i++){
        arr[i] = sc.nextInt();
      }

      Arrays.sort(arr);

      int value = arr[0];
      int count = 1 ;

      for (int i = 1 ; i< n ; i++){
               
        if( arr[i] == value){
            count++;
        }
        else{
            value = arr[i];
            System.out.println(arr[i-1] +" " +  count);
            count = 1;
        }
      }

      System.out.println(value + " " + count);
    }
}
