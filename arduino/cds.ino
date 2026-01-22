// C++ code
//

const int SENSOR_PIN = A0;
const int LED_PIN = 10;
void setup()
{
  pinMode(LED_PIN, OUTPUT);
  Serial.begin(9600);
}

void loop()
{
  int sensorValue = 0;
  sensorValue = analogRead(SENSOR_PIN);
  Serial.println(sensorValue);
  
  if (sensorValue < 500)
    digitalWrite(LED_PIN, HIGH);
  else digitalWrite(LED_PIN, LOW);
  
  delay(100);
}
