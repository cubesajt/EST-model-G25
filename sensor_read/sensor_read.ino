//pressure
const int pressurePin = A0;
const int offset = 201; // zero pressure adjust
const int fullScale = 1023; // max pressure adjust
float pressureType = 1000.0; // kPa
float pressure; // final pressure

//flow
byte sensorInterrupt = 0;  // 0 = digital pin 2
byte sensorPin       = 2;
float calibrationFactor = 4.5;
volatile byte pulseCount;  
float flowRate;
//unsigned int flowMilliLitres;
//unsigned long totalMilliLitres;
unsigned long oldTime;

const unsigned int sampleRate = 50; //in ms
const unsigned long startTime = millis();

void setup() {
  Serial.begin(9600);

  pulseCount        = 0;
  flowRate          = 0.0;
  //flowMilliLitres   = 0;
  //totalMilliLitres  = 0;
  oldTime           = 0;

  attachInterrupt(sensorInterrupt, pulseCounter, FALLING);
}

void loop() {
  if((millis() - oldTime) > sampleRate)
  { 
    // Disable the interrupt while calculating flow rate and sending the value to
    // the host
    detachInterrupt(sensorInterrupt);
        
    // Because this loop may not complete in exactly 1 second intervals we calculate
    // the number of milliseconds that have passed since the last execution and use
    // that to scale the output. We also apply the calibrationFactor to scale the output
    // based on the number of pulses per second per units of measure (litres/minute in
    // this case) coming from the sensor.
    flowRate = ((1000.0 / (millis() - oldTime)) * pulseCount) / calibrationFactor;
    
    // Pressure measurement
    pressure = (analogRead(pressurePin) - offset) * pressureType / (fullScale - offset);
    
    // Note the time this processing pass was executed. Note that because we've
    // disabled interrupts the millis() function won't actually be incrementing right
    // at this point, but it will still return the value it was set to just before
    // interrupts went away.
    oldTime = millis();
    
    // Divide the flow rate in litres/minute by 60 to determine how many litres have
    // passed through the sensor in this 1 second interval, then multiply by 1000 to
    // convert to millilitres.
    //flowMilliLitres = (flowRate / 60) * 1000;
    
    // Add the millilitres passed in this second to the cumulative total
    //totalMilliLitres += flowMilliLitres;
    
    // Print the flow rate for this second in litres / minute
    Serial.print(oldTime);
    Serial.print(", ");
    Serial.print(flowRate, 4);
    Serial.print(", ");
    Serial.println(pressure, 4);
    

    // Reset the pulse counter so we can start incrementing again
    pulseCount = 0;
    
    // Enable the interrupt again now that we've finished sending output
    attachInterrupt(sensorInterrupt, pulseCounter, FALLING);
  }  
}

void pulseCounter()
{
  // Increment the pulse counter
  pulseCount++;
}
