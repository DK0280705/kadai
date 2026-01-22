import java.util.Arrays;
import java.util.stream.*;

public enum State {
  START,
  MATCH,
}

public enum Result {
  TIE,
  WIN,
  LOSE,
}

public enum Hand {
  ROCK,
  PAPER,
  SCISSORS,
}

public class Vec2 {
  public float x;
  public float y;

  public Vec2(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public Vec2(Vec2 other) {
    this.x = other.x;
    this.y = other.y;
  }
}

public class Rect {
  public Vec2 position;
  public int width;
  public int height;

  public Rect(float x, float y, int width, int height) {
    this.position = new Vec2(x, y);
    this.width = width;
    this.height = height;
  }
  
  public Rect(Rect other) {
    this.position = new Vec2(other.position);
    this.width = other.width;
    this.height = other.height;
  }
}

public class Button {
  Rect rectangle;
  public String label;
  public int value;

  public boolean isDisabled;
  
  private PImage img;

  public Button(String label, PImage img, int value, Rect rectangle) {
    this.img = img;
    this.label = label;
    this.value = value;
    this.rectangle = rectangle;
    this.isDisabled = false;
  }
  public Button(Button other) {
    this.img = other.img;
    this.label = other.label;
    this.value = other.value;
    this.rectangle = new Rect(other.rectangle);
    this.isDisabled = other.isDisabled;
  }
  
  public void display() {
    pushStyle();
    textSize(36);
    fill(255, 255, 255, 0);
    if (isDisabled || this.isInRect(mouseX, mouseY)) {
      stroke(0);
      if (img != null) 
        image(img, rectangle.position.x + rectangle.width/2 - 32*3, rectangle.position.y - 216, 32*6, 32*6);
    } else {
      stroke(100);
    }
    strokeWeight(5);


    rect(rectangle.position.x, rectangle.position.y, rectangle.width, rectangle.height);
    if (!label.isEmpty()) {
      if (isDisabled || this.isInRect(mouseX, mouseY)) {
        fill(0);
      } else {
        fill(100);
      }
      text(label, rectangle.position.x + rectangle.width/2, rectangle.position.y + rectangle.height/2);
    }
    popStyle();
  }

  public boolean isInRect(int x, int y) {
    return x >= rectangle.position.x && x <= rectangle.position.x + rectangle.width &&
      y >= rectangle.position.y && y <= rectangle.position.y + rectangle.height;
  }
}

public class Timer {
  public int startTime;
  public int durationMs;
  public Timer(int durationMs) {
    this.durationMs = durationMs;
    this.startTime = millis();
  }
  public boolean isTimeout() {
    return durationMs - (millis() - startTime) < 0;
  }
}

public static Result evaluate(Hand usrHand, Hand comHand) {
  return Result.values()[(usrHand.ordinal() - comHand.ordinal() + 3) % 3];
}

ArrayList<Button> buttons;
ArrayList<Button> dummyButtons;
ArrayList<PImage> images;

void setup() { // init function
  size(1200,800);
  noSmooth();
  buttons = new ArrayList<Button>();
  images = new ArrayList<PImage>();
  for (Hand hand : Arrays.asList(Hand.ROCK, Hand.PAPER, Hand.SCISSORS)) {
    PImage image = loadImage(hand.toString().toLowerCase() + ".png");
    buttons.add(new Button(hand.toString(), image, hand.ordinal(), new Rect(width/2 - 72 + (hand.ordinal() - 1) * 288, height/2 + 144, 144, 64)));
  };

  dummyButtons = new ArrayList<>(buttons.stream().map(b -> new Button(b)).toList());
  dummyButtons.forEach(button -> {
    button.rectangle = new Rect(width/2 + 256 - button.rectangle.width/2, height/2 + 72, button.rectangle.width, button.rectangle.height);
    button.isDisabled = true;
  });
  
  retryButton = new Button("Retry", null, 0, new Rect(width/2 - 72, height/2 + 216, 144, 64));
  
  textAlign(CENTER, CENTER);
  textSize(24);
  PFont font = loadFont("AgencyFB-Bold-48.vlw");
  textFont(font);
}

State state = State.START;
Result result;

Hand usrHand;
Hand comHand;

Button retryButton;
Button pressedButton;
Timer setComputerHandTimer;
Timer showResultTimer;

// Scores
int playerScore;
int compScore;
int ties;

color bgColor = color(255, 255, 255);

void displayScores() {
  pushStyle();
  fill(200);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("You = " + str(playerScore) + " | Computer = " + str(compScore) + " | Ties = " + str(ties), width/2, height - 64);
  popStyle();
}

void draw() { // loop function
  background(bgColor);
  pushStyle();
  
  switch (state) {
    case START:
      for (Button button : buttons) {
        button.display();
      }
      textAlign(CENTER, CENTER);
      textSize(72);
      fill(100);
      text("Rock & Paper & Scissors", width/2, height/2 - 196);
      textSize(32);
      fill(200);
      text("Pick hand from buttons below", width/2, height/2 - 128);
      
      displayScores();
      break;
    case MATCH:
      pressedButton.display();
      pressedButton.rectangle.position.x = lerp(pressedButton.rectangle.position.x, width/2 - 256 - pressedButton.rectangle.width/2, 0.1);
      pressedButton.rectangle.position.y = lerp(pressedButton.rectangle.position.y, height/2 + 72, 0.1);
      textAlign(CENTER, CENTER);
      fill(0);
      textSize(48);
      text("Your Hand", width/2 - 256, height/2 - 196);
      text("Computer Hand", width/2 + 256, height/2 - 196);
      
      if (setComputerHandTimer != null && setComputerHandTimer.isTimeout()) {
        dummyButtons.get(comHand.ordinal()).display();
      } else {
        dummyButtons.get((int)random(3)).display();
      }
      
      if (showResultTimer != null && showResultTimer.isTimeout()) {
        bgColor = color(245);
        textSize(128);
        text(result.toString(), width/2, height/2);
        retryButton.display();
        displayScores();
      }
      
      break;
  }
  popStyle();
}

void mousePressed() {
  if (retryButton.isInRect(mouseX, mouseY)) {
    state = State.START;
    bgColor = color(255);
  }
  for (Button button : buttons) {
    if (!button.isDisabled && button.isInRect(mouseX, mouseY)) {
      usrHand = Hand.values()[button.value];
      comHand = Hand.values()[(int)random(3)];
      pressedButton = new Button(button);
      pressedButton.isDisabled = true;
      state = State.MATCH;
      result = evaluate(usrHand, comHand);
      setComputerHandTimer = new Timer(1000);
      showResultTimer = new Timer(2000);
      switch (result) {
        case TIE: ++ties; break;
        case WIN: ++playerScore; break;
        case LOSE: ++compScore; break;
      }
    }
  }
}
