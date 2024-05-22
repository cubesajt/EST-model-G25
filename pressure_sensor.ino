const int sensorPin = A0;
const int offset = 201; // zero pressure adjust
const int fullScale = 1023; // max pressure adjust
float sensorType = 1000.0; // kPa
float pressure; // final pressure
const unsigned long startTime = millis();

void setup() {
  Serial.begin(9600);
}

void loop() {
  unsigned long elapsedTime = millis() - startTime;
  pressure = (analogRead(sensorPin) - offset) * sensorType / (fullScale - offset);
  

  Serial.print(analogRead(sensorPin));
  //Serial.print("\t\t");
  //Serial.print(elapsedTime / 1000.0);  
  Serial.print("\t\t");
  Serial.println(pressure, 4);
  delay(100);
}
