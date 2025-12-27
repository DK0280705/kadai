PImage inImg;    // 入力画像 
PImage outImg1;   // 出力画像 
PImage outImg2;
PImage outImg3;
 
// 初期設定 
void setup() { 
  size (800, 600, P3D); 
 
  // 元画像を読み込む 
  inImg = loadImage("test.png"); 
} 
 
// メインルーチン 
void draw() { 
  background(0); 
 
  if (inImg.width > width/2 || inImg.height > height/2) { 
    inImg.resize(inImg.width/2, inImg.height/2);
  }
  // 左右反転した画像 outImg を作る 
  outImg1 = createImage(inImg.width, inImg.height, RGB); 
  for (int y = 0; y < inImg.height; y++) {       
    for (int x = 0; x < inImg.width; x++) { 
      int p1 = y * inImg.width + x; 
      int p2 = y * inImg.width + (inImg.width - 1 - x); 
      outImg1.pixels[p1] = inImg.pixels[p2];
    } 
  }
  outImg2 = createImage(inImg.width, inImg.height, RGB);
  for (int y = 0; y < inImg.height; y++) {       
    for (int x = 0; x < inImg.width; x++) { 
      int p1 = y * inImg.width + x; 
      int p2 = (inImg.height - 1 - y) * inImg.width + x; 
      outImg2.pixels[p1] = inImg.pixels[p2];
    } 
  }
  outImg3 = createImage(inImg.width, inImg.height, RGB);
  for (int y = 0; y < inImg.height; y++) {
    for (int x = 0; x < inImg.width; x++) { 
      int p1 = y * inImg.width + x; 
      int p2 = (inImg.height - 1 - y) * inImg.width + (inImg.width - 1 - x); 
      outImg3.pixels[p1] = inImg.pixels[p2];
    } 
  }
  // 画像を表示する 
  image(inImg, width/2 - inImg.width, height/2 - inImg.height);
  image(outImg1, width/2, height/2 - outImg1.height);
  image(outImg2, width/2 - outImg2.width, height/2);
  image(outImg3, width/2, height/2);
}
