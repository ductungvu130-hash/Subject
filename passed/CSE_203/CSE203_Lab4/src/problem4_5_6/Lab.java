package problem4_5_6;

public class Lab extends GradedActivity {
    private double labScore;

    public Lab(double labScore) {
        this.labScore = labScore;
        super.setPoints(labScore);
    }

    @Override
    public String toString() {
        return "Lab Score: " + labScore ;
    }



}
