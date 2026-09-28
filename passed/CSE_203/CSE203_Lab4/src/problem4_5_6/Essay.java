package problem4_5_6;

public class Essay extends GradedActivity {
    private double grammar;
    private double spelling;
    private double correctLength;
    private double content;

    private double totalScore;

    public Essay(double grammar, double spelling, double correctLength , double content) {
        this.content = content;
        this.correctLength = correctLength;
        this.grammar = grammar;
        this.spelling = spelling;
        totalScore = content + correctLength + grammar + spelling ;
        super.setPoints(totalScore);
    }

    @Override
    public String toString() {
        return "Essay Score: " + totalScore;
    }

    
}
