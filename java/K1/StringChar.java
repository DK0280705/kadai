public class StringChar {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Too few arguments.");
            return;
        }

        var str = args[0];
        var id = Integer.parseInt(args[1]);
        if (id < 0 || id >= str.length()) {
            System.out.println("Invalid input.");
            return;
        }
        System.out.println(str.charAt(id));
    }
}