import java.util.Scanner;

public class CompareString {
    public static void main(String[] args) {
        String str1 = new String();
        String str2 = new String();
        Scanner sc = new Scanner(System.in);
        System.out.print("Input string 1: ");
        str1 = sc.nextLine();
        System.out.print("Input string 2: ");
        str2 = sc.nextLine();
        if (str1.equals(str2)) {
            System.out.println("OK");
        } else {
            System.out.println("NG");
        }
    }
}