public class StringTest {
    public static void main(String[] args) {
        String s = "Only is not lonely.";
        
        // 1
        System.out.println("1." + s.length());
        // 2
        System.out.println("2." + s.startsWith("Only"));
        // 3
        System.out.println("3." + s.charAt(2));
        // 4
        System.out.println("4." + s.substring(5, 8));
        // 5
        System.out.println("5." + s.indexOf("n"));
        // 6
        System.out.println("6." + s.lastIndexOf("ly"));
        // 7
        System.out.println("7." + s.endsWith("."));
        // 8
        System.out.println("8." + s.toUpperCase());
        // 9
        System.out.println("9." + s.replaceAll(" ", "_"));
        // 10
        System.out.println("10." + s.split(" ")[1]);
    }
}
