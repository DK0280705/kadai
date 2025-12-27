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

  float factor = constrain((float)mouseX/(float)width, 0.0, 1.0);

  outImg = createImage(inImg.width, inImg.height, RGB);
  for (int y = 0; y < inImg.height; y++) {       
    for (int x = 0; x < inImg.width - 1; x++) { 
        int p = y * inImg.width + x;
        color c = inImg.pixels[p];
        float r = red(c);
        float g = green(c) * (1 - factor);
        float b = blue(c);
        outImg.pixels[p] = color(r, g, b);
    } 
  }
  text("Original", (width/2 - inImg.width - 10), (height/2 - inImg.height - 10));
  text("Processed", (width/2 + 10), (height/2 - outImg.height - 10));
  image(inImg, (width/2 - inImg.width - 10), (height/2 - inImg.height));
  image(outImg, (width/2 + 10), (height/2 - outImg.height));
}