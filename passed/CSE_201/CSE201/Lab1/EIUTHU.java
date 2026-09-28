import java.lang.*;
import java.util.*;

class EIUTHU
{
	public static void main (String[] args) throws java.lang.Exception
	{
		Scanner sc = new Scanner(System.in);
        String s1 = sc.nextLine();
        String s2 = sc.nextLine();
        
        char[] a = s1.toCharArray();
        char[] b = s2.toCharArray();
        int overlap = 0;
            
        for (int i = a.length; i > 0; i--) { 
        	 boolean match = true;
            for (int j = 0; j <i; j++) {
                if (a[a.length - i + j] != b[j]) {
                    match = false;
                    break;
                }
            }
            if (match) {
                overlap = i;
                break;
            }
           
        }

        int result = a.length + b.length - overlap;
        System.out.println(result);
	}
}