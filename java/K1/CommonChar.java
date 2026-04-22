public class CommonChar {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Too few arguments.");
            return;
        }
        String s1 = args[0].toLowerCase();
        String s2 = args[1].toLowerCase();

        boolean found = false;
        for (int i = 0; i < s1.length(); i++) {
            char c = s1.charAt(i);
            if (s2.indexOf(c) != -1) {
                found = true;
                System.out.print("[" + c + "]");
            }
        }

        if (!found) {
            System.out.print("None");
        }

        System.out.println();
    }
}
