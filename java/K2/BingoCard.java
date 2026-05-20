import java.util.Arrays;
import java.util.stream.IntStream;

public class BingoCard {
    private int[] data;
    final static int HIT = -1;

    BingoCard(int... nums) {
        data = nums;
    }

    public boolean doTry(int num) {
        var idx = IntStream
            .range(0, data.length)
            .filter(i -> data[i] == num)
            .findFirst();
        idx.ifPresent(i -> data[i] = HIT);
        return idx.isPresent();
    }

    public void show() {
        Arrays.stream(data).forEach(n -> {
            if (n == HIT) {
                System.out.print("[*]");
            } else {
                System.out.print("[" + n + "]");
            }
        });
        System.out.println();
    }

    public int getHitCount() {
        return (int) Arrays
            .stream(data)
            .filter(n -> n == HIT)
            .count();
    }

    public boolean isBingo() {
        return getHitCount() >= 3;
    }

    @Override
    public String toString() {
        System.out.println("BingoCard: " + Arrays
            .stream(data)
            .mapToObj(String::valueOf)
            .reduce((a, b) -> a + ", " + b)
            .orElse(""));
        return "";
    }     
}