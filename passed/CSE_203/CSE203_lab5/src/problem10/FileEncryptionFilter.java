package problem10;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Scanner;

public class FileEncryptionFilter {
    public static void encrypt(String input, String output) {
        try (FileInputStream in = new FileInputStream(input);
             FileOutputStream out = new FileOutputStream(output)) {

            int code = 10;
            int data;
            while ((data = in.read()) != -1) {
                int encryptedData = data+code;
                out.write(encryptedData);
            }
        } catch (IOException e) {
            System.out.println("There are some errors " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        String input = "src/problem10/inFile";
        String output = "src/problem10/outFile";

        encrypt(input,output);
    }
}
