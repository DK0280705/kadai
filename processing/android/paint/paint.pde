enum Tool {
	PENCIL,
	BRUSH,
	FILL,
	ERASER
}
Tool currentTool = Tool.PENCIL;
color backgroundColor = color(255);
color[] palette = {
	color(0),
	color(255, 0, 0),
	color(0, 140, 70),
	color(0, 100, 255),
	color(255, 180, 0),
	color(120, 70, 200)
};
int activeColorIndex = 0;

PGraphics canvas;

final float toolbarHeight = 140;
final float margin = 16;
final float buttonSize = toolbarHeight - (margin * 2);

float sliderStartX;
float sliderEndX;
float sliderY;
final float sliderTrackHeight = 10;
final float minSize = 2;
final float maxSize = 80;
float brushSize = 18;
boolean sliderActive = false;

boolean isDrawing = false;
PVector previousPoint;

void settings() {
  fullScreen(P2D);
}
void setup() {
	textFont(createFont("SansSerif", 26, true));

	canvas = createGraphics(width, int(height - toolbarHeight), P2D);
	canvas.beginDraw();
	canvas.background(backgroundColor);
	canvas.strokeCap(ROUND);
	canvas.strokeJoin(ROUND);
	canvas.endDraw();
	frameRate(60);

	sliderY = toolbarHeight / 2.0;
	// There's no dynamic resizing, so just compute once
	computeLayout();
}

void draw() {
	background(255);
	image(canvas, 0, toolbarHeight);
	drawToolbar();
}

void computeLayout() {
	float toolAreaWidth = margin + (buttonSize + margin) * 4;
	float swatchSize = getSwatchSize();
	float colorAreaWidth = margin + palette.length * (swatchSize + margin);
	float colorAreaLeft = max(toolAreaWidth + margin, width - colorAreaWidth);
	sliderStartX = toolAreaWidth + margin;
	sliderEndX = colorAreaLeft - margin;
	if (sliderEndX <= sliderStartX) {
		sliderEndX = sliderStartX + 60;
	}
	sliderEndX = min(sliderEndX, width - margin * 3);
	sliderY = toolbarHeight / 2.0;
}

float getSwatchSize() {
	return buttonSize * 0.75;
}

void drawToolbar() {
	noStroke();
	fill(250);
	rect(0, 0, width, toolbarHeight);

	drawToolButtons();
	drawSlider();
	drawColorPalette();

	fill(60);
	textAlign(LEFT, TOP);
	text("Size: " + nf(brushSize, 1, 1), sliderStartX, toolbarHeight - 32);
}

void drawToolButtons() {
	Tool[] tools = { Tool.PENCIL, Tool.BRUSH, Tool.FILL, Tool.ERASER };
	for (int i = 0; i < tools.length; i++) {
		float x = margin + i * (buttonSize + margin);
		float y = margin;
		boolean active = currentTool == tools[i];

		stroke(active ? color(0, 150, 255) : color(200));
		strokeWeight(4);
		fill(active ? color(230) : color(245));
		rect(x, y, buttonSize, buttonSize, 16);

		fill(60);
		textAlign(CENTER, CENTER);
		text(toolShortLabel(tools[i]), x + buttonSize / 2, y + buttonSize / 2);
	}
}

void drawSlider() {
	stroke(200);
	strokeWeight(4);
	line(sliderStartX, sliderY, sliderEndX, sliderY);

	float t = (brushSize - minSize) / (maxSize - minSize);
	float handleX = lerp(sliderStartX, sliderEndX, constrain(t, 0, 1));

	noStroke();
	fill(0, 150, 255);
	ellipse(handleX, sliderY, 28, 28);
}

void drawColorPalette() {
	float swatchSize = getSwatchSize();
	float colorAreaWidth = margin + palette.length * (swatchSize + margin);
	float startX = max(sliderEndX + margin * 2, width - colorAreaWidth + margin);
	float y = margin + (buttonSize - swatchSize) / 2;

	for (int i = 0; i < palette.length; i++) {
		float x = startX + i * (swatchSize + margin);
		stroke(activeColorIndex == i ? color(0, 150, 255) : color(200));
		strokeWeight(4);
		fill(palette[i]);
		rect(x, y, swatchSize, swatchSize, 12);
	}
}
void mousePressed() {
	handlePointerDown(mouseX, mouseY);
}
void mouseDragged() {
	handlePointerDrag(mouseX, mouseY);
}
void mouseReleased() {
	handlePointerUp();
}

void handlePointerDown(float x, float y) {
	if (y < toolbarHeight) {
		if (trySelectTool(x, y)) { return; }
		if (trySelectColor(x, y)) { return; }
		if (overSlider(x, y)) {
			sliderActive = true;
			updateBrushSizeFromSlider(x);
			return;
		}
		return;
	}
	sliderActive = false;

	float cy = y - toolbarHeight;
	if (!insideCanvas(x, cy)) { return; }

	if (currentTool == Tool.FILL) {
		floodFill(int(x), int(cy));
		return;
	}

	isDrawing = true;
	previousPoint = new PVector(x, cy);
	drawStroke(previousPoint.x, previousPoint.y, true);
}

void handlePointerDrag(float x, float y) {
	if (sliderActive) {
		updateBrushSizeFromSlider(x);
		return;
	}
	if (!isDrawing) { return; }
	float cy = y - toolbarHeight;
	if (!insideCanvas(x, cy)) { return; }
	drawStroke(x, cy, false);
}

void handlePointerUp() {
	isDrawing = false;
	sliderActive = false;
	previousPoint = null;
}

boolean trySelectTool(float x, float y) {
	Tool[] tools = { Tool.PENCIL, Tool.BRUSH, Tool.FILL, Tool.ERASER };
	for (int i = 0; i < tools.length; i++) {
		float bx = margin + i * (buttonSize + margin);
		float by = margin;
		if (insideRect(x, y, bx, by, buttonSize, buttonSize)) {
			currentTool = tools[i];
			return true;
		}
	}
	return false;
}

boolean trySelectColor(float x, float y) {
	float swatchSize = getSwatchSize();
	float colorAreaWidth = margin + palette.length * (swatchSize + margin);
	float startX = max(sliderEndX + margin * 2, width - colorAreaWidth + margin);
	float cy = margin + (buttonSize - swatchSize) / 2;
	for (int i = 0; i < palette.length; i++) {
		float bx = startX + i * (swatchSize + margin);
		if (insideRect(x, y, bx, cy, swatchSize, swatchSize)) {
			activeColorIndex = i;
			return true;
		}
	}
	return false;
}

boolean overSlider(float x, float y) {
	float handleRadius = 18;
	return x >= sliderStartX - handleRadius && x <= sliderEndX + handleRadius && abs(y - sliderY) <= handleRadius * 2;
}

void updateBrushSizeFromSlider(float x) {
	float t = (x - sliderStartX) / (sliderEndX - sliderStartX);
	t = constrain(t, 0, 1);
	brushSize = lerp(minSize, maxSize, t);
}

boolean insideCanvas(float x, float y) {
	return x >= 0 && x < canvas.width && y >= 0 && y < canvas.height;
}

void drawStroke(float x, float y, boolean initial) {
	if (!insideCanvas(x, y)) { return; }
	if (currentTool == Tool.ERASER) {
		drawBrushSegment(x, y, initial, backgroundColor);
		return;
	}
	if (currentTool == Tool.BRUSH) {
		drawBrushSegment(x, y, initial, palette[activeColorIndex]);
		return;
	}
	drawPencilStroke(x, y, initial);
}

void drawPencilStroke(float x, float y, boolean initial) {
	float weight = max(1, brushSize * 0.4);
	canvas.beginDraw();
	canvas.stroke(palette[activeColorIndex]);
	canvas.strokeWeight(weight);
	if (initial || previousPoint == null) {
		canvas.point(x, y);
	} else {
		canvas.line(previousPoint.x, previousPoint.y, x, y);
	}
	canvas.endDraw();
	if (previousPoint == null) {
		previousPoint = new PVector(x, y);
	} else {
		previousPoint.set(x, y);
	}
}

void drawBrushSegment(float x, float y, boolean initial, color c) {
	canvas.beginDraw();
	canvas.noStroke();
	canvas.fill(c);
	if (initial || previousPoint == null) {
		canvas.ellipse(x, y, brushSize, brushSize);
	} else {
		float distance = dist(previousPoint.x, previousPoint.y, x, y);
		int steps = max(1, int(distance / max(1, brushSize * 0.35)));
		for (int i = 1; i <= steps; i++) {
			float t = i / float(steps);
			float dx = lerp(previousPoint.x, x, t);
			float dy = lerp(previousPoint.y, y, t);
			canvas.ellipse(dx, dy, brushSize, brushSize);
		}
	}
	canvas.endDraw();
	if (previousPoint == null) {
		previousPoint = new PVector(x, y);
	} else {
		previousPoint.set(x, y);
	}
}

void floodFill(int x, int y) {
	if (!insideCanvas(x, y)) {
		return;
	}

	canvas.loadPixels();
	int w = canvas.width;
	int h = canvas.height;
	int targetColor = canvas.pixels[y * w + x];
	int replacement = palette[activeColorIndex];
	if (targetColor == replacement) {
		return;
	}

	IntList stackX = new IntList();
	IntList stackY = new IntList();
	stackX.append(x);
	stackY.append(y);

	while (stackX.size() > 0) {
		int cx = stackX.pop();
		int cy = stackY.pop();
		int idx = cy * w + cx;
		if (canvas.pixels[idx] != targetColor) {
			continue;
		}
		canvas.pixels[idx] = replacement;
		if (cx > 0) {
			stackX.append(cx - 1);
			stackY.append(cy);
		}
		if (cx < w - 1) {
			stackX.append(cx + 1);
			stackY.append(cy);
		}
		if (cy > 0) {
			stackX.append(cx);
			stackY.append(cy - 1);
		}
		if (cy < h - 1) {
			stackX.append(cx);
			stackY.append(cy + 1);
		}
	}

	canvas.updatePixels();
}

boolean insideRect(float px, float py, float rx, float ry, float rw, float rh) {
	return px >= rx && px <= rx + rw && py >= ry && py <= ry + rh;
}

String toolShortLabel(Tool t) {
	switch(t) {
	case PENCIL:
		return "P";
	case BRUSH:
		return "B";
	case FILL:
		return "F";
	case ERASER:
		return "E";
	}
	return "?";
}
