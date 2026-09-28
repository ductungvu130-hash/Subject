package problem4;

import java.util.HashMap;
import java.util.Map;

public class Card {
    private String suit;
    private String face;

    public Card(String face, String suit) {
        this.face = face;
        this.suit = suit;

    }

    public String getSuit() {
        return suit;
    }

    public void setSuit(String suit) {
        this.suit = suit;
    }

    public String getFace() {
        return face;
    }

    public void setFace(String face) {
        this.face = face;
    }

    @Override
    public String toString() {
        return "Value: "+face+"     | suit: "+suit;
    }
}
