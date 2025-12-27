import processing.video.*;
Capture cam;
PShader outline;
PImage inImg;
color target = #FF0000;
float colorThreshold = 0.08;
color outlineColor = #FFFF00;
float softness = 0.1;
float edgeScale = 2.5;
// 初期設定 
void setup() { 
  size (800, 600, P3D); 
 
  String[] settings = Capture.list();
  if (settings.length == 0) {
    println("There are no cameras");
    exit();
  }

  outline = loadShader("outline.glsl");

  cam = new Capture(this, settings[0]);
  cam.start();
} 
 
// メインルーチン 
void draw() { 
  background(0);

  if (cam.available() == true) {
    cam.read();
    inImg = cam;
  }

  if (inImg == null) {
    return;
  }

  inImg.loadPixels();

  outline.set("u_tex", inImg);
  outline.set("u_targetColor", red(target) / 255.0, green(target) / 255.0, blue(target) / 255.0);
  outline.set("u_threshold", colorThreshold);
  outline.set("u_outlineColor", red(outlineColor) / 255.0, green(outlineColor) / 255.0, blue(outlineColor) / 255.0);
  outline.set("u_texelSize", 1.0 / float(inImg.width), 1.0 / float(inImg.height));
  outline.set("u_softness", softness);
  outline.set("u_edgeScale", edgeScale);
  shader(outline);

  pushMatrix();
  translate(width/2 - inImg.width/2, height/2 - inImg.height/2);

  inImg.updatePixels();
  image(inImg, 0, 0);
  popMatrix();

  // Display mouse pointer and its pixel color in text
  loadPixels();
  if (mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < height) {
    int i = mouseY * width + mouseX;
    text("Mouse: (" + mouseX + ", " + mouseY + ")\nColor: #" + hex(pixels[i], 6), mouseX, mouseY + 10);
  }
  resetShader();
}

void mousePressed() {
  loadPixels();
  int i = mouseY * width + mouseX; 
  target = pixels[i];
}