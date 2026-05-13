public class CoinSetTest1 {
    public static void main(String[] args) {
        CoinSet cs = new CoinSet(4, 3);
        System.out.println("残りのコイン: " + cs);
        System.out.println("500円取り出し: " + cs.take(500));
        System.out.println();
        System.out.println("残りのコイン: " + cs);
        System.out.println("300円取り出し: " + cs.take(300));
        System.out.println();
        System.out.println("残りのコイン: " + cs);
        System.out.println("20円取り出し: " + cs.take(20));
        System.out.println();
        System.out.println("残りのコイン: " + cs);
        System.out.println("5円取り出し: " + cs.take(5));
        System.out.println();
        System.out.println("残りのコイン: " + cs);
        System.out.println("40円取り出し: " + cs.take(40));
    }
} 