import de.voidplus.leapmotion.*;

LeapMotion leap;
float steeringAngle = 0;
float wheelVelocity = 0;
PVector lastHandPos = new PVector();
boolean wasGrabbing = false;

void setup() {
  size(800, 500, P3D);
  leap = new LeapMotion(this);
}

void draw() {
  background(50);
  
  ArrayList<Hand> hands = leap.getHands();
  boolean isGrabbing = false;
  
  // Wheel position (Lowered)
  float wheelX = width/2;
  float wheelY = height * 0.75;
  PVector wheelCenter = new PVector(wheelX, wheelY);
  
  if (hands.size() > 0) {
    Hand h = hands.get(0);
    
    // Check for grab
    if (h.getGrabStrength() > 0.5) {
      isGrabbing = true;
      PVector currentHandPos = h.getPosition();
      
      if (wasGrabbing) {
        PVector handVelocity = PVector.sub(currentHandPos, lastHandPos);
        PVector radiusVector = PVector.sub(currentHandPos, wheelCenter);
        
        // Angular Change = (r x v) / r^2
        float crossProduct = radiusVector.x * handVelocity.y - radiusVector.y * handVelocity.x;
        float distSq = radiusVector.magSq();
        
        // Apply rotation if we are not too close to center (avoid singularities)
        if (distSq > 500) {
           float angularChange = crossProduct / distSq;
           steeringAngle += angularChange;
           wheelVelocity = angularChange;
        }
      }
      lastHandPos = currentHandPos.copy();
    }
  }
  
  wasGrabbing = isGrabbing;
  
  // Apply Physics (Inertia & Friction) when not grabbing
  if (!isGrabbing) {
    steeringAngle += wheelVelocity;
    wheelVelocity *= 0.95;
  }
  
  drawSteeringWheel(isGrabbing, wheelX, wheelY);
  drawInstructions(hands.size(), isGrabbing);
}

void drawSteeringWheel(boolean active, float x, float y) {
  pushMatrix();
  translate(x, y);
  
  rotateZ(steeringAngle);
  
  // Draw Wheel
  noFill();
  strokeWeight(15);
  if (active) {
    stroke(0, 255, 0); 
  } else {
    stroke(255); 
  }
  ellipse(0, 0, 300, 300); // Outer rim
  
  // Draw Center Hub
  fill(255);
  noStroke();
  ellipse(0, 0, 50, 50);
  
  // Draw Spokes
  stroke(255);
  strokeWeight(15);
  line(-25, 0, -150, 0); 
  line(25, 0, 150, 0);   
  line(0, 25, 0, 150);   
  
  // Visual indicator
  fill(255, 0, 0);
  noStroke();
  rectMode(CENTER);
  rect(0, -150, 20, 40); 
  
  popMatrix();
}

void drawInstructions(int handCount, boolean isGrabbing) {
  fill(255);
  textSize(20);
  textAlign(CENTER);
  
  text("Direct Steering Mode", width/2, 30);
  
  if (isGrabbing) {
    fill(0, 255, 0);
    text("Steering Active", width/2, 60);
  } else {
    fill(200);
    text("Grab to take control", width/2, 60);
  }
  
  fill(255);
  text("Angle: " + nf(degrees(steeringAngle), 0, 1), width/2, 90);
}