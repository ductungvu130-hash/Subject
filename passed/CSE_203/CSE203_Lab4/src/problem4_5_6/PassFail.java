package problem4_5_6;

public class PassFail extends GradedActivity{
    private int correctQuestion;
    private static final double ScoreEachQueation = 10;

    public PassFail(int correctQuestion) {
        this.correctQuestion = correctQuestion;
        super.setPoints(ScoreEachQueation* correctQuestion); 
    }

    @Override
    public String toString() {
        return "PassFail Score: " + getPoints();
    }

    

}
