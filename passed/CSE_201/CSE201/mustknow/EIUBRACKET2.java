import java.util.*;

public class EIUBRACKET2 {
    public static void main(String[] args) throws Exception {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
            
            while (n > 0) {
                String s = sc.next();
                if (isValid(s)) {
                    System.out.println("true");
                } else {
                    System.out.println("false");
                }
                n--;
            }
        }
       

    public static boolean isValid(String s) {
        Stack<Character> stack = new Stack<>();
        
        for (int i =0 ; i < s.length(); i++) {
           char c = s.charAt(i);
            if (c == '(' || c == '{' || c == '[') {
                stack.push(c);
            } 
           
            else {
               
                if (stack.isEmpty()) {
                    return false;
                }

                char top = stack.peek(); 
               
                if (c == ')' && top == '(') {
                    stack.pop(); 
                } else if (c == '}' && top == '{') {
                    stack.pop();
                } else if (c == ']' && top == '[') {
                    stack.pop();
                } else {
                    
                    return false;
                }
            }
        }

        return stack.isEmpty();
    }
}
