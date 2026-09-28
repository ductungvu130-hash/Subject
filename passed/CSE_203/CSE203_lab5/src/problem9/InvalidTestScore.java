package problem9;

import problem8.TestScores;
public class InvalidTestScore extends RuntimeException{
    public InvalidTestScore(){
        super("This score is invalid. This must stand between 0 and 100.");
    }
    public InvalidTestScore(String message){
        super(message);
    }
}
