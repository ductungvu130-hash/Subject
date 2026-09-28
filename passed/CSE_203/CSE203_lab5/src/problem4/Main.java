package problem4;

public class Main {
    public static void main(String[] args) {
        Deck cardTable = new Deck();
        cardTable.shuffles();

        CardPlayer player1 = new CardPlayer();
//        CardPlayer player2 = new CardPlayer();

        for(int i=0;i<5;i++){
            player1.getCard(cardTable.deals());
//            player2.getCard(cardTable.deals());
        }
        System.out.println("<=====The cards of player 1 are=====>");
        player1.showCards();
//        System.out.println("<=====The cards of player 2 are=====>");
//        player2.showCards();
    }
}
