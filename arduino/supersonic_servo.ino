#include <Servo.h>
#define TRIGPIN 13
#define ECHOPIN 12

#define SERVO 10

Servo servo;

void setup()
{
  Serial.begin(9600);
  pinMode(TRIGPIN, OUTPUT);
  pinMode(ECHOPIN, INPUT);
  servo.attach(SERVO, 500, 2500);
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

  if (distance < 50) {
    servo.write(90);
  } else if (distance > 50 || distance < 300) {
    servo.write(180);
  } else {
    servo.write(0);
  }

  Serial.print(distance);
  Serial.println(" cm");

  delay(1000);
}
