public class Rectangle {
    public int width;
    public int height;
    public boolean isFilled;
    public int getArea() {
        return width * height;
    }
    public void draw() {
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                if (isFilled) {
                    System.out.print("*");
                } else {
                    if (i == 0 || i == height - 1 || j == 0 || j == width - 1) {
                        System.out.print("*");
                    } else {
                        System.out.print(" ");
                    }
                }            
            }
            System.out.println();
        }
    }
}