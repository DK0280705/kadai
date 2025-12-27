import processing.video.*;
Capture cam;
PImage inImg;
color target = #FF0000;

// 初期設定 
void setup() { 
  size (800, 600, P3D); 
 
  String[] settings = Capture.list();
  if (settings.length == 0) {
    println("There are no cameras");
    exit();
  }

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

  ArrayList<PVector> hits = new ArrayList<PVector>();
  
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
        hits.add(new PVector(x, y));
      }
    } 
  }
 
  pushMatrix();
  translate(width/2 - inImg.width/2, height/2 - inImg.height/2);
  stroke(255, 255, 0);
  strokeWeight(2);
  noFill();
  if (hits.size() > 2) {
    ArrayList<PVector> hull = convexHull(hits);
    beginShape();
    for (PVector v : hull) {
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
  }

  inImg.updatePixels();
  image(inImg, 0, 0);
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

// Monotonic chain convex hull (Graham scan variant)
ArrayList<PVector> convexHull(ArrayList<PVector> pts) {
  ArrayList<PVector> points = new ArrayList<PVector>(pts);
  // Sort points lexicographically
  points.sort((a, b) -> a.x != b.x ? Float.compare(a.x, b.x) : Float.compare(a.y, b.y));
  if (points.size() <= 1) return points;

  ArrayList<PVector> lower = new ArrayList<PVector>();
  for (PVector p : points) {
    while (lower.size() >= 2 && cross(sub(lower.get(lower.size()-1), lower.get(lower.size()-2)), sub(p, lower.get(lower.size()-2))) <= 0) {
      lower.remove(lower.size()-1);
    }
    lower.add(p);
  }

  ArrayList<PVector> upper = new ArrayList<PVector>();
  for (int i = points.size() - 1; i >= 0; i--) {
    PVector p = points.get(i);
    while (upper.size() >= 2 && cross(sub(upper.get(upper.size()-1), upper.get(upper.size()-2)), sub(p, upper.get(upper.size()-2))) <= 0) {
      upper.remove(upper.size()-1);
    }
    upper.add(p);
  }

  lower.remove(lower.size()-1);
  upper.remove(upper.size()-1);
  lower.addAll(upper);
  return lower;
}

PVector sub(PVector a, PVector b) {
  return new PVector(a.x - b.x, a.y - b.y);
}

float cross(PVector a, PVector b) {
  return a.x * b.y - a.y * b.x;
}