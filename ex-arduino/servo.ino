#include <Servo.h>

Servo servo;

void setup()
{
  servo.attach(10, 500, 2500);
}

void loop()
{
  servo.write(90);
  delay(1000);
  servo.write(0);
  delay(1000);
}
