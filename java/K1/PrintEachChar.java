import java.util.Scanner;

public class PrintEachChar {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Input: ");
        String str = sc.nextLine();
        for (int i = 0; i < str.length(); i++) {
            System.out.println(i + ": " + str.charAt(i));
        }
    }
}