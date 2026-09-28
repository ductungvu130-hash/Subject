package problem4_5_6;

public class Main {
    public static void main(String[] args) {
        GradedActivity essay = new Essay(30, 20, 10, 20);
        GradedActivity lab = new Lab(80);
        GradedActivity passfail = new PassFail(3);
        GradedActivity fianl = new FinalExam(90);


        CourseGrades stu1 = new CourseGrades();

        stu1.setEssay(essay);
        stu1.setFinalExam(fianl);
        stu1.setLab(lab);
        stu1.setPassFail(passfail);

        System.out.println(stu1.toString());
    }

}
