import processing.video.*;
import gifAnimation.*;
Capture cam;
PImage inImg;
Gif swordGif;
color target = #FF0000;
int posX, posY;
float lastMillis = 0;
float length = 80;
float damping = 6;
PVector linearVelocity = new PVector();
PVector angleVelocity = new PVector();
PVector rotation = new PVector();
PVector position = new PVector();
float stiffness = 12; // fast position follow

// 初期設定 
void setup() { 
  size (800, 600, P3D); 
 
  swordGif = new Gif(this, "sword.gif");
  swordGif.loop();

  String[] settings = Capture.list();
  if (settings.length == 0) {
    println("There are no cameras");
    exit();
  }

  cam = new Capture(this, settings[0]);
  cam.start();
  lastMillis = millis();
} 
 
// メインルーチン 
void draw() { 
  float now = millis();
  float dt = (now - lastMillis) / 1000.0;
  lastMillis = now;

  background(0); 
  if (cam.available() == true) {
    cam.read();
    inImg = cam;
    inImg.loadPixels();
  }

  ArrayList<PVector> hits = new ArrayList<PVector>();
  float tr = red(target);
  float tg = green(target);
  float tb = blue(target);
  float tmag = sqrt(tr*tr + tg*tg + tb*tb);
  float minMag = 100;
  float cosThreshold = 0.97;
  
  for (int y = 0; y < inImg.height; y++) {       
    for (int x = 0; x < inImg.width; x++) { 
      int p = y * inImg.width + x;
      color c = inImg.pixels[p];
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      float mag = sqrt(r*r + g*g + b*b);
      if (mag > minMag && tmag > minMag) {
        float cosSim = (r*tr + g*tg + b*tb) / (mag * tmag);
        // Cosine Similarity thresholding
        if (cosSim > cosThreshold) {
          hits.add(new PVector(x, y));
        }
      }
    } 
  }

  posX = width/2 - inImg.width/2;
  posY = height/2 - inImg.height/2;
 
  pushMatrix();
  translate(posX, posY);
  inImg.updatePixels();
  image(inImg, 0, 0);
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

    // Estimate dominant direction from hull points and draw it at the hull centroid
    PVector centroid = hullCentroid(hull);
    PVector centroidDist = PVector.sub(centroid, position);
    centroidDist.mult(stiffness);
    linearVelocity.add(PVector.mult(centroidDist, dt));
    linearVelocity.mult(max(0, 1 - damping * dt));
    position.add(PVector.mult(linearVelocity, dt));

    PVector direction = hullDirection(hull, centroid);

    if (direction != null) {
      PVector angularDist = PVector.sub(direction, rotation);
      angularDist.mult(stiffness);
      angleVelocity.add(PVector.mult(angularDist, dt));
      angleVelocity.mult(max(0, 1 - damping * dt));
      rotation.add(PVector.mult(angleVelocity, dt));

      PVector tip = PVector.add(position, rotation.copy().setMag(length));
      stroke(0, 255, 255);
      strokeWeight(3);
      line(position.x, position.y, tip.x, tip.y);
      // Arrow head
      PVector rotCopy = rotation.copy();
      rotCopy.normalize();
      PVector left = PVector.add(tip, PVector.mult(new PVector(-rotCopy.y, rotCopy.x), 12));
      PVector right = PVector.add(tip, PVector.mult(new PVector(rotCopy.y, -rotCopy.x), 12));
      line(tip.x, tip.y, left.x, left.y);
      line(tip.x, tip.y, right.x, right.y);

      if (swordGif != null) {
        float baseOffset = 24;
        PVector dir = rotCopy.copy();
        PVector swordPos = PVector.add(tip, dir.copy().mult(baseOffset));
        float swordAngle = atan2(dir.y, dir.x) + HALF_PI;

        pushMatrix();
        translate(swordPos.x, swordPos.y);
        rotate(swordAngle);
        image(swordGif, -swordGif.width / 2.0, -swordGif.height / 2.0);
        popMatrix();
      }
    } else {
      // Decay when no direction available
      angleVelocity.mult(max(0, 1 - damping * dt));
      rotation.mult(max(0, 1 - damping * dt));
      linearVelocity.mult(max(0, 1 - damping * dt));
      position.mult(max(0, 1 - damping * dt));
    }
  }
  popMatrix();

  // Display mouse pointer and its pixel color in text
  if (mouseX < posX || mouseX >= posX + inImg.width || mouseY < posY || mouseY >= posY + inImg.height) {
    return;
  }

  int i = (mouseY - posY) * inImg.width + (mouseX - posX);
  text("Mouse: (" + mouseX + ", " + mouseY + ")\nColor: #" + hex(inImg.pixels[i], 6), mouseX, mouseY + 10);
}

void mousePressed() {
  if (mouseX < posX || mouseX >= posX + inImg.width || mouseY < posY || mouseY >= posY + inImg.height) {
    return;
  }
  int i = (mouseY - posY) * inImg.width + (mouseX - posX); 
  target = inImg.pixels[i];
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

PVector hullCentroid(ArrayList<PVector> pts) {
  float sumX = 0;
  float sumY = 0;
  for (PVector p : pts) {
    sumX += p.x;
    sumY += p.y;
  }
  return new PVector(sumX / pts.size(), sumY / pts.size());
}

// Principal axis via covariance; returns unit vector
PVector hullDirection(ArrayList<PVector> pts, PVector centroid) {
  float xx = 0;
  float xy = 0;
  float yy = 0;
  for (PVector p : pts) {
    float dx = p.x - centroid.x;
    float dy = p.y - centroid.y;
    xx += dx * dx;
    xy += dx * dy;
    yy += dy * dy;
  }
  int n = pts.size();
  if (n < 2) return null;
  xx /= n;
  xy /= n;
  yy /= n;
  if (xx + yy == 0) return null;
  float angle = 0.5 * atan2(2 * xy, xx - yy);
  return new PVector(cos(angle), sin(angle));
}

PVector sub(PVector a, PVector b) {
  return new PVector(a.x - b.x, a.y - b.y);
}

float cross(PVector a, PVector b) {
  return a.x * b.y - a.y * b.x;
}