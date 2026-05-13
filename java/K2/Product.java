public class Product {
    int id;
    String name;
    boolean soldout;

    public Product(int id, String name, boolean soldout) {
        this.id = id;
        this.name = name;
        this.soldout = soldout;
    }

    @Override
    public String toString() {
        return "No." + id + " " + name + (soldout ? " (品切れ中)" : "");
    }
}