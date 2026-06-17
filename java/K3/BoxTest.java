class BoxTest {
    public static void main(String[] args) {
        Box box1 = new Box();
        box1.draw();
        System.out.println("--------");
        Box box2 = new Box(2, 5);
        box2.draw();
    }
}
