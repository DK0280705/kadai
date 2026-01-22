import java.util.Random;
import java.util.Scanner;

public class NumGame {
    public static void main(String[] args) {
        var rand = new Random();
        int num = rand.nextInt(9) + 1;
        var sc = new Scanner(System.in);
        while (true) {
            System.out.print("Guess: ");
            int guess = sc.nextInt();
            if (guess < 1 || guess > 10) {
                System.out.println("ERROR");
                continue;
            }
            if (guess < num) {
                System.out.println("LOW");
            } else if (guess > num) {
                System.out.println("HIGH");
            } else {
                System.out.println("Correct!");
                break;
            }
        }
        sc.close();
    }
}