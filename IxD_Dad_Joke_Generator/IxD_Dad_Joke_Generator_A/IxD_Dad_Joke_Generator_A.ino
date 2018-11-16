// Declare potentiometer on Analog pin A0
int potentiometer = A0;
// Declare button sensor on digital pin A1
int button_sensor = 8;

//setting up so button doesn't send close together
long previousMillis = 0;
long interval = 500;

void setup() {
  // put your setup code here, to run once:
  // Start a serial connection with a baud rate of 9600
  Serial.begin(9600);

  // Set the sensor pins to be inputs
  pinMode(potentiometer, INPUT);
  pinMode(button_sensor, INPUT);


}

void loop() {

  // check to see if it's time to blink the LED; that is, if the 
  // difference between the current time and last time you 
  // pressed the button
  unsigned long currentMillis = millis();


  // Read the value of the potentiometer sensor and assign it to a variable called 'val'
  int val = analogRead(potentiometer); // get analog value
  
  // Convert the temperature value to integer and send it via a serial port
  Serial.print(val);
  // Send a TAB symbol for separation
  Serial.print("\t");
  
  // Read the value of the button and assign it to a variable called 'val'  
  // Send the 'val' and the TAB symbol down the serial port
  val = digitalRead(button_sensor);
  Serial.print(val);
  Serial.print("\t");

//  if(currentMillis - previousMillis > interval) {
//    // save the last time you blinked the LED 
//    previousMillis = currentMillis;   
// 
//    // if the LED is off turn it on and vice-versa:
//    if (button_sensor == 1) {
////      ledState = HIGH;
//        val = digitalRead(button_sensor);
//        Serial.print(val);
//        Serial.print("\t");
//    }
//    else {
//      val = 0;
//      Serial.print(val);
//      Serial.print("\t");
//    }
//    // set the LED with the ledState of the variable:
//  }
  
  Serial.println();
  // Take a breather for 200 milliseconds
  delay(200);
}
