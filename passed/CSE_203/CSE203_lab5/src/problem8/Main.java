package problem8;

public class Main {
    public static void main(String[] args) {
        testScoreArray(new double[]{});

        testScoreArray(new double[]{10.5,20,101,-1});

        testScoreArray(new double[]{10,20,50,100,40,44,90.5});
    }

    public static void testScoreArray(double[] sl){
        try{
            TestScores score = new TestScores(sl);
            System.out.println(score.getAverage());
        }catch (IllegalArgumentException e){
            System.out.println(e.getMessage());
        }
    }
}
