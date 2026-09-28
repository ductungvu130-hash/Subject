import java.util.Scanner;

public class EIUPH011 {

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int  n = sc.nextInt();

		int[] arr = new int [n];

		int [] check = new int[1000000];

		for(int i  =0 ; i < n ; i++){
			int x = sc.nextInt();
			arr[i] = x;
			check[x]++;
		}

		for (int i = 0 ; i < n; i++){
			if(check[arr[i]] >= 1){
				check[arr[i]] = 0;
				System.out.print(arr[i] + " ");
			}
		}

		
	}
}