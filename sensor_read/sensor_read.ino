const float fullScale = 1023; // conversion to volts

// Pressure
const unsigned char pressurePin = A0;
//const int offset = 205; // zero pressure adjust
//float pressureType = 1000.0; // kPa
float pressure; // final pressure
const unsigned int bufferSize = 10;
float buffer[bufferSize];
float buffered = 0;
int currentStep = 1;


//flow
const unsigned char flowPin = A1;
float flowRate = 0;
//unsigned int flowMilliLitres;
//unsigned long totalMilliLitres;
unsigned long oldTime;

const unsigned int sampleRate = 5; //in ms
const unsigned long startTime = millis();

void setup() {
  //Serial.begin(115200);
  Serial.begin(9600);


  oldTime = 0;

  for(int i = 0; i < 10; i++){
    buffer[i] = 0;
  }
}

void loop() {
  if((millis() - oldTime) > sampleRate)
  { 
        
    // Because this loop may not complete in exactly 1 second intervals we calculate
    // the number of milliseconds that have passed since the last execution and use
    // that to scale the output. We also apply the calibrationFactor to scale the output
    // based on the number of pulses per second per units of measure (litres/minute in
    // this case) coming from the sensor.
    flowRate = (analogRead(flowPin) * (5 / fullScale)) * 45 - 25; // In l/m
    if (flowRate < 20){
      flowRate = 0;
    }

    // Pressure measurement
    pressure = (analogRead(pressurePin) * (5 / fullScale) - 1) * 250000 / 100000; // In bars

    if (flowRate < 0){
      flowRate = 0;
    }
    if (pressure < 0){
      pressure = 0;
    }
    
    // Note the time this processing pass was executed. Note that because we've
    // disabled interrupts the millis() function won't actually be incrementing right
    // at this point, but it will still return the value it was set to just before
    // interrupts went away.
    oldTime = millis();
    
    //flowMilliLitres = (flowRate / 60) * 1000;
    
    //totalMilliLitres += flowMilliLitres;
    
    // Print the flow rate for this second in litres / minute
    Serial.print(float(oldTime) / 1000, 3);
    Serial.print(", ");
    Serial.print(flowRate, 4);
    Serial.print(", ");
    Serial.print(pressure, 4);
    Serial.print(", ");
    
    buffer[currentStep % bufferSize] = pressure;
    currentStep++;
    buffered = 0;
    for (int i = 0; i < bufferSize; i++){
      buffered += buffer[i];
    }
    buffered = buffered/bufferSize;
    
    Serial.println(buffered);
  }  
}