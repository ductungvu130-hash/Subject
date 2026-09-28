package problem4;

import java.util.ArrayList;
import java.util.List;

public class CardPlayer {
    private List<Card> cards;

    public CardPlayer() {
        this.cards = new ArrayList<>();
    }

    public void getCard(Card card) {
        cards.add(card);
    }

   public void showCards(){
        StringBuilder oBuilder = new StringBuilder();
        for(Card c:cards){
            oBuilder.append(c.toString()).append("\n");
        }

       System.out.println(oBuilder);
   }
}
