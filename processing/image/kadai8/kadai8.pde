import processing.video.*;
Capture cam;
PImage inImg;
PImage outImg;
color target = #FF0000;

// 初期設定 
void setup() { 
  size (800, 600, P3D); 
 
  String[] settings = Capture.list();
  if (settings.length == 0) {
    println("There are no cameras");
    exit();
  }

  outImg = loadImage("test.png");

  cam = new Capture(this, settings[0]);
  cam.start();
} 
 
// メインルーチン 
void draw() { 
  background(0); 
  if (cam.available() == true) {
    cam.read();
    inImg = cam;
    inImg.loadPixels();
  }

  int xmin, xmax, ymin, ymax;
  xmin = inImg.width;
  xmax = 0;
  ymin = inImg.height;
  ymax = 0;
  
  for (int y = 0; y < inImg.height; y++) {       
    for (int x = 0; x < inImg.width; x++) { 
      int p = y * inImg.width + x;
      color c = inImg.pixels[p];
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      float tr = red(target);
      float tg = green(target);
      float tb = blue(target);
      float dist = dist(r, g, b, tr, tg, tb);
      if (dist < 50) {
        if (x < xmin) {
          xmin = x;
        }
        if (x > xmax) {
          xmax = x;
        }
        if (y < ymin) {
          ymin = y;
        }
        if (y > ymax) {
          ymax = y;
        }
      }
    } 
  }
  inImg.updatePixels();
 
  pushMatrix();
  translate(width/2 - inImg.width/2, height/2 - inImg.height/2);
  image(inImg, 0, 0);

  stroke(255, 255, 0);
  noFill();
  if (xmax > xmin && ymax > ymin) {
    int w = xmax - xmin;
    int h = ymax - ymin;
    PGraphics pg = createGraphics(w, h);
    pg.beginDraw();
    pg.image(outImg, 0, 0, w, h);
    pg.endDraw();
    image(pg, xmin, ymin);
    rect(xmin, ymin, xmax - xmin, ymax - ymin);
  }  
  popMatrix();

  // Display mouse pointer and its pixel color in text
  loadPixels();
  int i = mouseY * width + mouseX;
  text("Mouse: (" + mouseX + ", " + mouseY + ")\nColor: #" + hex(pixels[i], 6), mouseX, mouseY + 10);
}

void mousePressed() {
  loadPixels();
  int i = mouseY * width + mouseX; 
  target = pixels[i];
}
