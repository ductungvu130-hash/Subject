package problem1_2_3;

import java.time.LocalDate;

public class Demonstration {
    public static void main(String[] args) {
        
    TeamLeader leader = new TeamLeader(
            "Nguyen Van An", 
            "888-A", 
            LocalDate.of(2020, 10, 30), 
            1, 
            30.00, 
            500.00, 
            20.0, 
            5.0
        );

        leader.checknumber();
        System.out.println(leader);
    }
}
