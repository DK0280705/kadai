import java.util.Scanner;

public class ReversePrint {
    public static void main(String[] args) {
        var scanner = new Scanner(System.in);
        String s = scanner.nextLine();

        for (int i = s.length() - 1; i >= 0; i--) {
            System.out.print(s.charAt(i));
        }
        System.out.println();

        scanner.close();
    }
}
