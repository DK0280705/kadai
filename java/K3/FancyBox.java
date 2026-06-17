class FancyBox extends Box {
    boolean fills;    // 箱を塗りつぶすならtrue
    char character;   // 箱を描画する文字

    FancyBox() {
       super();
       this.fills = true;
       this.character = '*';
    }
    FancyBox(int height, int width, boolean fills, char character) {
       super(height, width);
       this.fills = fills;
       this.character = character;
    }

    @Override
    void draw() {
       for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                if (fills) {
                    System.out.print(character);
                } else {
                    if (i == 0 || i == height - 1 || j == 0 || j == width - 1) {
                        System.out.print(character);
                    } else {
                        System.out.print(" ");
                    }
                }
            }
            System.out.println();
        }
    }
}