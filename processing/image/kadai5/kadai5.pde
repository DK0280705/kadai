PImage inImg;
PImage outImg;

// マウスの x 座標に応じて緑成分が減るように実装
void setup() {
  size(800, 600, P3D);
  inImg = loadImage("test.png");
  surface.setResizable(true);
}

void draw() {
  background(0);

  if (inImg.width > width/2 || inImg.height > height/2) { 
    inImg.resize(inImg.width/2, inImg.height/2);
  }

  outImg = createImage(inImg.width, inImg.height, RGB);
  for (int y = 0; y < inImg.height; y++) {       
    for (int x = 0; x < inImg.width - 1; x++) { 
        int p = y * inImg.width + x;
        float r = 0.0;
        float g = 0.0;
        float b = 0.0;
        for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
                int nx = constrain(x + i, 0, inImg.width - 1);
                int ny = constrain(y + j, 0, inImg.height - 1);
                int np = ny * inImg.width + nx;
                color nc = inImg.pixels[np];
                r += red(nc);
                g += green(nc);
                b += blue(nc);
            }
        }
        outImg.pixels[p] = color(r / 9.0, g / 9.0, b / 9.0);
    } 
  }
  text("Original", (width/2 - inImg.width - 10), (height/2 - inImg.height - 10));
  text("Processed", (width/2 + 10), (height/2 - outImg.height - 10));
  image(inImg, (width/2 - inImg.width - 10), (height/2 - inImg.height));
  image(outImg, (width/2 + 10), (height/2 - outImg.height));
}