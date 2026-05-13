import java.util.Scanner;

public class CoinSetTest2 {
    public static void main(String[] args) {
        if (args.length != 2) {
            System.out.println("Usage: java CoinSetTest2 <coin100> <coin10>");
            return;
        }
        int coin100 = Integer.parseInt(args[0]);
        int coin10 = Integer.parseInt(args[1]);
        CoinSet cs = new CoinSet(coin100, coin10);

        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("現在のコイン: " + cs);
            System.out.print("金額は？： ");
            int amount = scanner.nextInt();
            if (amount <= 0) {
                System.out.println("終了します。");
                break;
            }
            if (cs.take(amount)) {
                System.out.println(amount + "円取り出しました。");
            } else {
                System.out.println("取り出せません。");
            }
            System.out.println();
        }

        scanner.close();
    }
    
}
