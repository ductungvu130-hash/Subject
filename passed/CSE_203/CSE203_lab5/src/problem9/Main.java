package problem9;


public class Main {
    public static void main(String[] args) {
        testInvalidArray(null);

        testInvalidArray(new double[]{});

        testInvalidArray(new double[]{10.5,20,100,-1});

        testInvalidArray(new double[]{10.5,20,10,100,99});
    }

    public static void testInvalidArray(double[] sl){
        try{
            TestScores score = new TestScores(sl);
            System.out.println(score.getAverage());
        }catch(InvalidTestScore e){
            System.out.println(e.getMessage());
        }
    }
}
