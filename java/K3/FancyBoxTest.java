class FancyBoxTest {
    public static void main(String[] args) {
        FancyBox fbox1 = new FancyBox(2, 3, true,'+');
        fbox1.draw();
        System.out.println("--------");
        FancyBox fbox2 = new FancyBox(3, 4, false,'#');
        fbox2.draw();
        System.out.println("--------");
        FancyBox fbox3 = new FancyBox();
        fbox3.draw();
    }
}