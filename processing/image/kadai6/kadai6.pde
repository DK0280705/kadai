import processing.video.*;
Capture cam;
PImage inImg;    // 入力画像 
PImage outImg1;   // 出力画像 
PImage outImg2;
PImage outImg3;
 
// 初期設定 
void setup() { 
  size (800, 600, P3D); 
  surface.setResizable(true);
 
  String[] settings = Capture.list();
  if (settings.length == 0) {
    println("There are no cameras");
    exit();
  }

  cam = new Capture(this, settings[0]);
  cam.start();
  printArray(settings);
} 
 
// メインルーチン 
void draw() { 
  background(0); 
  if (cam.available() == true) {
    cam.read();
    inImg = cam;
    inImg.loadPixels();
  }

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

  inImg.updatePixels();
  // 画像を表示する 
  image(inImg, width/2 - inImg.width, height/2 - inImg.height);
  image(outImg1, width/2, height/2 - outImg1.height);
  image(outImg2, width/2 - outImg2.width, height/2);
  image(outImg3, width/2, height/2);
}
