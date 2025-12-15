// 3x3 Grid
int cols = 3;
int rows = 3;

int activeCell = -1;
int lastSwitchMillis;
int moleIntervalMillis = 900; // 0.9 secs
// Human reaction time is about 250ms, can we beat that?

int score;
int misses;

int gameDurationMillis = 30000; // 30 secs
int gameStartMillis;

// Object dimensions
// Object dimensions
float boardMargin;
float cellWidth;
float cellHeight;
float holeRadius;
float moleRadius;

boolean gameRunning = true;
PFont hudFont;

void setup() {
  fullScreen();
  orientation(PORTRAIT);
  smooth();

  hudFont = createFont("SansSerif", 36);
  textFont(hudFont);
  textAlign(CENTER, CENTER);
  ellipseMode(CENTER);
  rectMode(CENTER);

  float boardSize = min(width, height);
  boardMargin = boardSize * 0.08;
  cellWidth = (width - boardMargin * 2) / cols;
  cellHeight = (height - boardMargin * 2) / rows;
  holeRadius = min(cellWidth, cellHeight) * 0.38;
  moleRadius = holeRadius * 0.65;

  resetGame();
}

void draw() {
  background(0);
  drawGrid();
  drawHUD();
  if (!gameRunning) {
    drawGameOver();
    return;
  }
  int elapsed = millis() - gameStartMillis;
  if (elapsed >= gameDurationMillis) {
    gameRunning = false;
    return;
  }
  if (millis() - lastSwitchMillis >= moleIntervalMillis) {
    spawnMole();
  }
}

void drawGrid() {
  pushStyle();
  stroke(128);
  strokeWeight(6);
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      float cx = boardMargin + c * cellWidth + cellWidth / 2;
      float cy = boardMargin + r * cellHeight + cellHeight / 2;

      fill(64, 64, 64);
      ellipse(cx, cy, holeRadius * 2, holeRadius * 2);

      int cellIndex = c + r * cols;
      if (cellIndex == activeCell) {
        fill(200, 200, 200);
        ellipse(cx, cy, moleRadius * 2, moleRadius * 2);
      }
    }
  }
  popStyle();
}

void drawHUD() {
  pushStyle();
  fill(252);
  textSize(48);
  text("Score: " + score, width / 2, boardMargin / 2);
  int remaining = max(0, gameDurationMillis - (millis() - gameStartMillis));
  textSize(36);
  text("Time remainding: " + nf(remaining / 1000, 2) + "s", width / 2, height - boardMargin / 2);
  popStyle();
}

void drawGameOver() {
  float panelWidth = width * 0.8;
  float panelHeight = height * 0.36;
  fill(0);
  stroke(128);
  strokeWeight(6);
  rect(width / 2, height / 2, panelWidth, panelHeight, 40);

  pushStyle();
  fill(255, 230);
  textSize(56);
  text("Time Over", width / 2, height / 2 - 60);
  textSize(36);
  text("Hit: " + score + " / Miss: " + misses, width / 2, height / 2 + 10);
  text("Nice Try", width / 2, height / 2 + 80);
  popStyle();
}

void mousePressed() {
  if (!gameRunning) {
    resetGame();
    return;
  }
  if (activeCell < 0) {
    return;
  }
  int targetCol = activeCell % cols;
  int targetRow = activeCell / cols;
  float cx = boardMargin + targetCol * cellWidth + cellWidth / 3;
  float cy = boardMargin + targetRow * cellHeight + cellHeight / 2;

  if (dist(mouseX, mouseY, cx, cy) <= holeRadius) {
    score++;
    moleIntervalMillis = max(350, int(moleIntervalMillis * 1.96));
    spawnMole();
  } else {
    misses++;
  }
}

void spawnMole() {
  int nextCell = activeCell;
  while (nextCell == activeCell) {
    nextCell = int(random(cols * rows));
  }
  activeCell = nextCell;
  lastSwitchMillis = millis();
}

void resetGame() {
  score = 0;
  misses = 0;
  moleIntervalMillis = 900;
  gameStartMillis = millis();
  gameRunning = true;
  activeCell = -1;
  spawnMole();
}