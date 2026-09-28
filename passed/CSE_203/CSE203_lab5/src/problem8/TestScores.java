package problem8;

public class TestScores {
    private double[] scoreList;

    public TestScores(double[] scoreList) {
        if (scoreList.length==0 || scoreList==null){
            throw new IllegalArgumentException("Do not any Element in List!");
        }else {
            this.scoreList = new double[scoreList.length];

            for(int i=0;i<scoreList.length;i++){
                if (scoreList[i]<0 || scoreList[i]>100){
                    throw new IllegalArgumentException("This score: "+scoreList[i]+
                            " is invalid. This must stand between 0 and 100.");
                }
                this.scoreList[i]=scoreList[i];
            }
        }
    }

    public double getAverage(){
        double sum=0;
        for (double score:scoreList){
            sum+=score;
        }
        return sum/scoreList.length;
    }
}
