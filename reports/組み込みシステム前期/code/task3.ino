const int SW_PIN = 2;
const int LED_PINS[] = {8, 9, 10};
const int NUM_LEDS = 3;

int currentLed = 0;
int lastSwState = HIGH;
unsigned long lastDebounceTime = 0;
unsigned long debounceDelay = 50;

void setup() {
  pinMode(SW_PIN, INPUT_PULLUP);
  for (int i = 0; i < NUM_LEDS; i++) {
    pinMode(LED_PINS[i], OUTPUT);
  }
  updateLeds();
}

void loop() {
  int currentSwState = digitalRead(SW_PIN);

  if (currentSwState != lastSwState) {
    lastDebounceTime = millis();
  }

  if ((millis() - lastDebounceTime) < debounceDelay) return;

  if (lastSwState != HIGH && currentSwState == LOW) {
    currentLed = (currentLed + 1) % NUM_LEDS;
    updateLeds();
  }

  lastSwState = currentSwState;
}

void updateLeds() {
  for (int i = 0; i < NUM_LEDS; i++) {
    digitalWrite(LED_PINS[i], (i == currentLed) ? HIGH : LOW);
  }
}
