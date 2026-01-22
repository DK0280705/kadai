import java.util.ArrayList;
import java.util.Scanner;

public class SumTest {
    public static void main(String[] args) {
        var sc = new Scanner(System.in);
        System.out.print("How many?: ");
        int n = sc.nextInt();
        var numbers = new ArrayList<Integer>();
        for (int i = 1; i <= n; i++) {
            System.out.print("Input number: ");
            int num = sc.nextInt();
            numbers.add(num);
        }
        double average = numbers
            .stream()
            .mapToInt(Integer::intValue)
            .average()
            .orElse(0);
        int max = numbers
            .stream()
            .mapToInt(Integer::intValue) 
            .max()
            .orElse(0);
        System.out.println("average: " + average);
        System.out.println("max: " + max);
    }
}