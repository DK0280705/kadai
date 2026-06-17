class Box {
    int height;
    int width;

    Box() {
        height = 3;
        width = 3;
    }

    Box(int height, int width) {
        this.height = height;
        this.width = width;
    }

    void draw() {
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                System.out.print('*');
            }
            System.out.println();
        }
    }
}