package problem5;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Map;
import java.util.Scanner;
import java.util.TreeMap;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        boolean flag = false;
        Map<String, Integer> wordMap = new TreeMap<>();
        while (!flag) {
            String fileName = sc.nextLine();

            try (Scanner fileScanner = new Scanner(new File("src/problem5/", fileName))) {
                while (fileScanner.hasNext()) {
                    String word = fileScanner.next();
                    word = word.replaceAll("[^a-zA-Z]", "");

                    if (!word.isEmpty()) {
                        wordMap.put(word, wordMap.getOrDefault(word, 0) + 1);
                    }

                    flag=true;
                }
            } catch (FileNotFoundException e) {
                System.out.println("File's name is not exist, rewrite,please!");
            } catch (Exception e) {
                System.out.println("There happen some problems!" + e.getMessage());
                break;
            }
        }

        //          print
        for (Map.Entry<String, Integer> entry : wordMap.entrySet()) {
            System.out.printf("%-20s %d%n", entry.getKey(), entry.getValue());
        }
    }

}
