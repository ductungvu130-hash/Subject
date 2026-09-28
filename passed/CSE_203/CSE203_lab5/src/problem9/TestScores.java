package problem9;

public class TestScores {
    private double[] scoreList;

    public TestScores(double[] scoreList) {
        if (scoreList==null){
            throw new InvalidTestScore("This list is null");
        }
        if (scoreList.length==0){
            throw new InvalidTestScore("There is not any score in Score List");
        }
        this.scoreList = new double[scoreList.length];

        for(int i =0;i<scoreList.length;i++){
            if (scoreList[i]<0 || scoreList[i]>100){
                throw new InvalidTestScore();
            }
            this.scoreList[i]=scoreList[i];
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
