package problem4_5_6;

public class FinalExam extends GradedActivity{
    private double finalScore;

    public FinalExam(double finalScore) {
        this.finalScore = finalScore;
        super.setPoints(finalScore);
    }

    @Override
    public String toString() {
        return "Final Exam:  " + finalScore ;
    }

    
}
