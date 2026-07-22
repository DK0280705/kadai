const int SW_PIN = 2;
const int LED_PINS[] = {8, 9, 10};
const int NUM_LEDS = 3;

int currentLed = 0;
int lastSwState = HIGH;

void setup() {
  pinMode(SW_PIN, INPUT_PULLUP);
  for (int i = 0; i < NUM_LEDS; i++) {
    pinMode(LED_PINS[i], OUTPUT);
  }
  updateLeds();
}

void loop() {
  int swState = digitalRead(SW_PIN);

  if (lastSwState == HIGH && swState == LOW) {
    currentLed = (currentLed + 1) % NUM_LEDS;
    updateLeds();
  }

  lastSwState = swState;
}

void updateLeds() {
  for (int i = 0; i < NUM_LEDS; i++) {
    digitalWrite(LED_PINS[i], (i == currentLed) ? HIGH : LOW);
  }
}
