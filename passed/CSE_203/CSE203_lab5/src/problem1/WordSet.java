package problem1;

import java.util.*;

public class WordSet {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter input line");
        
        String input = sc.nextLine();

        String [] tokens = input.toLowerCase().split(" ");

        Set<String> wordset = new TreeSet<>();

        for(String words : tokens){
            wordset.add(words);
        }

        for(String uniqueWord : wordset){
            System.out.print(" _ " + uniqueWord);
        }
        
    }

    
}
