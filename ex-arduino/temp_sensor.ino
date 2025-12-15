const int ANALOG_PIN = 0;

void setup()
{
  Serial.begin(9600);
}

void loop()
{
  int sensorValue = 0;
  float Vout, temp;
  
  sensorValue = analogRead(ANALOG_PIN);
  Vout = map(sensorValue, 0, 1023, 0, 5000);
  temp = map(Vout, 300, 1600, -30, 100);

  Serial.println(temp);

  delay(1000);
}
