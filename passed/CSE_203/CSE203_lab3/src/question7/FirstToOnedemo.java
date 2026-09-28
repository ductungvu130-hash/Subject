package question7;

import question6.Dice;


public class FirstToOnedemo {
    public static void main(String[] args) {
        
        Dice die = new Dice(6);

        Player p1 = new Player("Player 1");
        Player p2 = new Player("Player 2");

        

        while (p1.getPoints() != 1 && p2.getPoints() != 1) {
            playTurn(p1, die);
            playTurn(p2, die);
        }

        
        
        if (p1.getPoints() == 1) {
            System.out.println("Winner " + p1.getName() );
        } else {
            System.out.println("Winner " + p2.getName() );
        }
    }

   
    public static void playTurn(Player player, Dice die) {
        die.roll();
        int rollValue = die.getValue();
        int oldPoints = player.getPoints();
        player.updatePoints(rollValue);
        
        System.out.printf("%s have: %d | Point: %d -> %d\n", 
                                  player.getName(), rollValue, oldPoints, player.getPoints());
    }
}