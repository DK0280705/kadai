import de.voidplus.leapmotion.*;

// Line-art cards controlled with Leap Motion swipes and key-taps.
LeapMotion leap;
ArrayList<Card> cards;
float railOffset;      // horizontal offset for the whole rail
float railVelocity;    // inertial velocity applied from swipe gestures
float railAccel;       // acceleration applied each frame
float railMinOffset;
float railMaxOffset;
int lastMillis;        // for delta-time integration
int lastClickMillis;   // debounce hand-movement click
PVector lastPointer;   // track prior hand position for gesture detection

void setup() {
  size(1000, 650, P3D);
  smooth(8);
  leap = new LeapMotion(this);
  leap.allowGestures();

  cards = new ArrayList<Card>();
  float spacing = 230;
  float railY = height * 0.55;
  for (int i = 0; i < 6; i++) {
    cards.add(new Card(i * spacing, railY, 180, 260, "Card " + (i + 1)));
  }

  float centerRail = (cards.get(0).x + cards.get(cards.size() - 1).x) * 0.5;
  railOffset = width * 0.5 - centerRail;
  railMinOffset = width * 0.2 - cards.get(cards.size() - 1).x;
  railMaxOffset = width * 0.8 - cards.get(0).x;
  lastMillis = millis();
  lastClickMillis = 0;
  lastPointer = null;
}

void draw() {
  background(255);
  scale(1,1,-1);

  // Delta time in seconds for frame-rate independent physics.
  int now = millis();
  float dt = (now - lastMillis) / 1000.0;
  lastMillis = now;

  // Simple acceleration-based physics with drag, edge spring, and center snap.
  float drag = 5.0;            // higher = quicker slow-down
  float spring = 40.0;         // edge stiffness when pulled past bounds
  float snap = 20.0;            // center snap velocity gain when almost stopped
  railAccel = -railVelocity * drag;

  // Edge spring to keep the rail feeling grounded.
  if (railOffset < railMinOffset) {
    railAccel += (railMinOffset - railOffset) * spring - railVelocity * (drag * 0.5);
  } else if (railOffset > railMaxOffset) {
    railAccel -= (railOffset - railMaxOffset) * spring + railVelocity * (drag * 0.5);
  }

  // Always steer velocity toward nearest card center for continuous snap.
  float targetOffset = railOffset;
  float closest = Float.MAX_VALUE;
  float viewCenter = width * 0.5;
  for (Card c : cards) {
    float cx = c.x + railOffset;
    float dist = abs(cx - viewCenter);
    if (dist < closest) {
      closest = dist;
      targetOffset = railOffset + (viewCenter - cx);
    }
  }
  float d = targetOffset - railOffset;
  float desiredVel = d * snap; // proportional steering toward center
  float blend = 1.0 - exp(-6.0 * dt); // smooth, dt-aware blend
  railVelocity = lerp(railVelocity, desiredVel, blend);

  railVelocity += railAccel * dt;
  railOffset += railVelocity * dt;

  Hand activeHand = leap.getHands().size() > 0 ? leap.getHands().get(0) : null;
  PVector pointer = activeHand != null ? activeHand.getStabilizedPosition() : null;

  Card hovered = null;
  for (Card c : cards) {
    boolean isHover = pointer != null && c.contains(pointer.x, pointer.y, railOffset);
    if (isHover) hovered = c;
    c.setHover(isHover);
    c.update();
    c.draw(railOffset);
  }

  // Hand movement click: quick forward or downward thrust triggers click on hovered card.
  if (activeHand != null && pointer != null && hovered != null) {
    if (lastPointer == null) {
      lastPointer = pointer.copy();
    }
    PVector delta = PVector.sub(pointer, lastPointer);
    int nowMs = millis();
    boolean thrust = delta.y > 15; // sudden hand down movement
    if (thrust && nowMs - lastClickMillis > 350) {
      hovered.click();
      lastClickMillis = nowMs;
    }
    lastPointer.set(pointer);
  } else {
    lastPointer = pointer != null ? pointer.copy() : null;
  }
}

void leapOnSwipeGesture(SwipeGesture g, int state) {
  if (state == 1) {
    railVelocity += g.getDirection().x * (g.getSpeed() * 0.2);
  }
}

class Card {
  float x, y, w, h;
  float scaleFactor = 1.0;
  float targetScale = 1.0;
  String label;
  boolean clicked = false;
  int clickedAt = 0;

  Card(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  boolean contains(float px, float py, float offset) {
    float cx = x + offset;
    float hoverMargin = 22;
    float range = max(w, h) * 0.5 * scaleFactor + hoverMargin;
    return dist(px, py, cx, y) <= range;
  }

  void setHover(boolean active) {
    targetScale = active ? 1.08 : 1.0;
  }

  void click() {
    println("clicked", label);
    clicked = true;
    clickedAt = millis();
    targetScale = 0.9;
  }

  void update() {
    scaleFactor = lerp(scaleFactor, targetScale, 0.18);
    // Nudge back to neutral after click completes.
    if (abs(scaleFactor - targetScale) < 0.01 && targetScale < 1.0) {
      targetScale = 1.0;
    }
    if (clicked && millis() - clickedAt > 600) {
      clicked = false;
    }
  }

  void draw(float offset) {
    float cx = x + offset;
    pushMatrix();
    translate(cx, y);
    scale(scaleFactor);
    stroke(0);
    if (clicked) {
      fill(0, 180, 0);
    } else {
      noFill();
    }
    strokeWeight(2);
    rectMode(CENTER);
    rect(0, 0, w, h);
    line(-w * 0.4, -h * 0.2, w * 0.4, -h * 0.2);
    line(-w * 0.4, 0, w * 0.4, 0);
    line(-w * 0.4, h * 0.2, w * 0.4, h * 0.2);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, 0, h * 0.42);
    popMatrix();
  }
}