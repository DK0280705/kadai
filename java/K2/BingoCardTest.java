class BingoCardTest {
    public static void main(String[] args) {
        BingoCard bc = new BingoCard(2, 3, 5);
        System.out.println(bc);

        for (int i = 1; i < 10; i++) {
            System.out.println("Try: " + i + ", Result: " + bc.doTry(i));
            bc.show();
            System.out.println("Hit count: " + bc.getHitCount());
            if (bc.isBingo()) {
                System.out.println("BINGO!");
                System.out.println(bc);
                break;
            }
            System.out.println("----------------------");
        }
    }
}