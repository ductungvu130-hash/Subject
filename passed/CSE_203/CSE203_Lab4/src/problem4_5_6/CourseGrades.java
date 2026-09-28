package problem4_5_6;

import java.util.Arrays;

public class CourseGrades implements Analyzable{
   private GradedActivity [] grade ;

    public CourseGrades() {
        this.grade = new GradedActivity[4] ;
    }

    public void setLab( GradedActivity lab){
        this.grade[0] = lab; 
    }

    public void setPassFail(GradedActivity passFail){
        this.grade[1] = passFail;
    }

    public void setEssay(GradedActivity essay){
        this.grade[2] = essay;
    }

    public void setFinalExam(GradedActivity finalExam){
        this.grade[3] = finalExam;
    }

    // @Override
    // public String toString() {
    //     return "Course Grades : " + Arrays.toString(grade) ;
    // }

    @Override
    public double getAverage(){
        double avg = 0.0;
        for(int i = 0 ; i< 4; i++){
            avg =avg + this.grade[i].getPoints();
            
        }
        return avg/=4;
    }

    @Override
    public GradedActivity getHighest(){
        int max = 0;
        for(int i = 1 ; i< 4; i++){
            if(grade[max].getPoints() < grade[i].getPoints()){
                max = i;
            }
            
        }
        return grade[max];
    }

     @Override
    public GradedActivity getLowest(){
        int min = 0;
        for(int i = 1 ; i< 4; i++){
            if(grade[min].getPoints() > grade[i].getPoints()){
                min = i;
            }
            
        }
        return grade[min];
    }

     @Override
     public String toString() {
        return "Course Grades " + Arrays.toString(grade) + "\nAverage Score: " + getAverage() + "\nHighest Score: "
                + getHighest() + "\nLowest Score: " + getLowest();
     }

    
}
