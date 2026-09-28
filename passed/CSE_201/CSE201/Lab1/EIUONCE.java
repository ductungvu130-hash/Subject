import java.util.*;
public class EIUONCE {
    public static void main(String[] args) throws Exception {
      Scanner sc = new Scanner(System.in);
      StringBuilder sb = new StringBuilder();

      int n = sc.nextInt();

      for (int i = 0 ; i < n ; i++){
        
        int k = sc.nextInt();
        int [] arr = new int[k];
        for(int j = 0 ; j < k ;j++){
            arr[j] = sc.nextInt();
        }

        Arrays.sort(arr);
        
        for (int a =0 ; a < arr.length; a++){
            if(a == 0){
                if (arr[a] < arr[a+1]){
                    sb.append(arr[a]).append(" ");
                }
            }
            else if( a == k -1){
                if (arr[a] > arr[a-1]){
                    sb.append(arr[a]).append(" ");
                }
            }
            else if (arr[a] > arr[a-1] & arr[a]< arr[a+1]){
                sb.append(arr[a]).append(" ");
            }
        }
        System.out.println(sb.toString());

      }


    }
    
    
}


