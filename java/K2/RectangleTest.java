public class RectangleTest {
    public static void main(String[] args) {
        System.out.println("--- r1 ---");
        Rectangle r1 = new Rectangle();
        r1.height = 4;
        r1.width = 6;
        r1.isFilled = true;
        System.out.println("Area: " + r1.getArea());
        r1.draw();

        System.out.println("--- r2 ---");
        Rectangle r2 = new Rectangle();
        r2.height = 5;
        r2.width = 7;
        r2.isFilled = false;
        System.out.println("Area: " + r2.getArea());
        r2.draw();
    }
}
