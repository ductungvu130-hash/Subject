package question7;

public class Player {
    private String name;
    private int points;

    public Player(String name) {
        this.name = name;
        this.points = 50; 
    }

    public String getName() { return name; }
    public int getPoints() { return points; }

    
    public void updatePoints(int rollValue) {
        if (points - rollValue == 1) {
            points = 1; 
        } else if (points - rollValue < 1) {
            points += rollValue; 
        } else {
            points -= rollValue; 
        }
    }
}
