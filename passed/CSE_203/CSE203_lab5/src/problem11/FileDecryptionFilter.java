package problem11;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class FileDecryptionFilter {
    public static void decrypt(String inPath,String outPath){
        try(FileInputStream in = new FileInputStream(inPath);
            FileOutputStream out = new FileOutputStream(outPath)){

            int data;
            int code=10;
            while ((data = in.read())!=-1){
                out.write(data-code);
            }
        }catch (IOException e){
            System.out.println("There are some errors "+e.getMessage());
        }
    }

    public static void main(String[] args) {
        String input = "src/problem11/inFile";
        String output = "src/problem11/outFile";

        decrypt(input,output);
    }
}
