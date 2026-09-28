package problem4;

import java.util.*;

public class Deck{
    List<Card> deck;


    public Deck() {
        this.deck = new ArrayList<>();

        String[] suits = {"Heart", "Diamond", "Spade", "Club"};
        String[] value = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"};
        for(String face:value){
            for(String suit:suits){
                deck.add(new Card(face,suit));
            }
        }
    }

    public void shuffles(){
        Collections.shuffle(deck);
    }

    public Card deals(){
        if (deck.isEmpty()) {
            return null;
        }
        return deck.remove(0);
    }
}
