#define TRIGPIN 13
#define ECHOPIN 12
#define LED 11
#define LED2 10

void setup()
{
  Serial.begin(9600);
  pinMode(TRIGPIN, OUTPUT);
  pinMode(ECHOPIN, INPUT);
  pinMode(LED, OUTPUT);
  pinMode(LED2, OUTPUT);
}

void loop()
{
  long duration, distance;

  digitalWrite(TRIGPIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIGPIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIGPIN, LOW);
  duration = pulseIn(ECHOPIN, HIGH);
  distance = (duration/2) * 0.000001 * 343 * 100;

  if (distance < 150) {
    digitalWrite(LED, HIGH);
    digitalWrite(LED2, LOW);
  } else {
    digitalWrite(LED, LOW);
    digitalWrite(LED2, HIGH);
  }

  if (distance >= 300 || distance <= 4) {
    digitalWrite(LED, LOW);
    digitalWrite(LED2, LOW);
    Serial.println("Out of range");
    Serial.print(distance);
    Serial.println(" cm");
  } else {
    Serial.print(distance);
    Serial.println(" cm");
  }
  delay(500);
}
