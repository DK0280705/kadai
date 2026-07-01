import java.util.Random;
import java.util.Scanner;

public class SimpleGame {
    public static void main(String[] args) {
        Card[] cards = new Card[3];
        for (int i = 0; i < 3; i++) {
            cards[i] = new Card();
            System.out.println((i + 1) + ". " + cards[i]);
        }

        System.out.println();
        Scanner scan = new Scanner(System.in);
        System.out.print("Which one?: ");

        int usrCardId = scan.nextInt();
        if (usrCardId > 3 || usrCardId < 1)
            throw new IllegalArgumentException("Invalid Card");
        Random rnd = new Random();
        int comCardId = rnd.nextInt(3);

        Card usrCard = cards[usrCardId - 1];
        Card comCard = cards[comCardId];

        System.out.println("You: " + usrCard);
        System.out.println("CPU: " + comCard);
        
        System.out.println(
            usrCard.isSameAs(comCard) 
                ? "Draw"
                : usrCard.isStrongerThan(comCard) ? "You win!" : "You lose."
        );
    }
}