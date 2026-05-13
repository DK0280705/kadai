public class ProductTest {
    public static void main(String[] args) {
        Product p1 = new Product(11, "Lenovo ThinkPad T14", false);
        System.out.println("p1の文字列表現は、「" + p1 + "」です。");
        Product p2 = new Product(33, "Nintendo Switch2", true);
        System.out.println("Productのインスタンスp2をprintlnで出力します:");
        System.out.println(p2);
    }     
}
