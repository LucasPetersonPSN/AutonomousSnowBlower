//Setting the values for serial communication
const int serialBaudRate = 9600;
const int eStopPin = 13;
int counter = 0;

//Setting the values for the battery monitor pins
const int battery12VPin = A0;
const int battery40VPin = A1;
const float voltageReference = 5.0; // Arduino ADC reference (5V for most boards)
const int adcMax = 1023;            // 10-bit ADC resolution
const double nom40V = 40;
const double cut40V = 33;
const double res40Vtop = 91180;  //So about 2.009V to 1.658V
const double res40Vbot = 4823.5;
const double nom12V = 12.8;
const double cut12V = 10;
const double res12Vtop = 40398;  //So abaout 4.24V to 3.31V
const double res12Vbot = 20003;
const double divRatio40V = res40Vbot / (res40Vtop + res40Vbot);
const double divRatio12V = res12Vbot / (res12Vtop + res12Vbot);


//Setting the values for the motor driver control pins nad the relay control pin
const int motorLeft = 12;  //TO DIR
const int motorRight = 8;  //TO DIR
const int speedLeft = 10;  //TO ENB
const int speedRight = 11;  //TO ENA
const int augerCont = 9;
const int leftEncoderPin = 2;   // Must be interrupt-capable
const int rightEncoderPin = 3;  // Must be interrupt-capable
volatile long leftEncoderCount = 0;
volatile long rightEncoderCount = 0;
long prevLeftEncoder = 0;
long prevRightEncoder = 0;
int baseSpeed = 150;  //Default speed of motors before encoder adjustment, only when encoders are used
float Kp = 1.0;  //Proportional gain of encoder controller

//Setting the values for the motor driver queues **TROUBLESHOOT HERE**
const String forward = "Forward";
const String backward = "Backward";
const String leftTurn = "Left";
const String rightTurn = "Right";
const String allStop = "Stop";
const String augerStart = "GoAug";
const String augerStop = "CeaseAug";
const String recEStop = "JetEStop";
const String sendEStop = "ArdEStop";
const String recClear = "JetAllClear";
const String sendClear = "ArdAllClear";
const int refreshRate = 200;  //In miliseconds, has min of 50, max of 1000 (sensor limits), nominal 200

//Setting the values for the ultrasonic sensor control pins
const int trigLeft = 6;
const int echoLeft = 7;
const int trigRight = 2;  //**ENCODER CONFLICT
const int echoRight = 3;  //**ENCODER CONFLICT
const int trigRear = 4;
const int echoRear = 5;
int rSpeed = 0;
int lSpeed = 0;

//Debugging flags
const bool takeSonicData = false;
const bool listenForCommands = true;
const bool useMotorEncoders = false;
const bool isEStop = false;

void setup() {
    //Setting the baud rate
    Serial.begin(serialBaudRate);
    pinMode(eStopPin, INPUT_PULLUP);

    //Setting the motor driver control pins
    pinMode(motorLeft, OUTPUT);
    pinMode(motorRight, OUTPUT);
    pinMode(speedLeft, OUTPUT);
    pinMode(speedRight, OUTPUT);

    if (useMotorEncoders) {
        pinMode(leftEncoderPin, INPUT_PULLUP);
        pinMode(rightEncoderPin, INPUT_PULLUP);
        attachInterrupt(digitalPinToInterrupt(leftEncoderPin), leftEncoderISR, RISING);
        attachInterrupt(digitalPinToInterrupt(rightEncoderPin), rightEncoderISR, RISING);
    }

    //Setting the ultrasonic sensor control pins
    pinMode(trigLeft, OUTPUT);
    pinMode(echoLeft, INPUT);
    pinMode(trigRight, OUTPUT);
    pinMode(echoRight, INPUT);
    pinMode(trigRear, OUTPUT);
    pinMode(echoRear, INPUT);
}

long readUltrasonic(int trigPin, int echoPin) {
    digitalWrite(trigPin, LOW);  //Ensure trigger is off
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH);  //Send the required 10 microsecond pulse
    delayMicroseconds(10);  //The higher the time, the chance for a more stable echo
    digitalWrite(trigPin, LOW);
    
    long duration = pulseIn(echoPin, HIGH);
    long distance = duration * 0.034 / 2;  //Half of the time it takes when traveling the speed of sound in air (343 m/s)
    return distance;
}

void leftEncoderISR() {
  leftEncoderCount++;
}

void rightEncoderISR() {
  rightEncoderCount++;
}

void balanceSpeed() {
  long leftDelta = leftEncoderCount - prevLeftEncoder;
  long rightDelta = rightEncoderCount - prevRightEncoder;

  int error = leftDelta - rightDelta;
  int adjustment = Kp * error;

  int rightSpeed = baseSpeed + adjustment;
  rightSpeed = constrain(rightSpeed, 0, 255); // keep in PWM range

  analogWrite(speedLeft, baseSpeed);
  analogWrite(speedRight, rightSpeed);

  prevLeftEncoder = leftEncoderCount;
  prevRightEncoder = rightEncoderCount;
}

void listenSerial() {
    if (Serial.available() > 0) {
        //Read the command
        String command = Serial.readStringUntil('\n');
        
        //Motor Control
        if (command == forward) {
            digitalWrite(motorLeft, LOW);
            digitalWrite(motorRight, LOW);
            
            if (useMotorEncoders)
                balanceSpeed();
            else {
                analogWrite(speedLeft, baseSpeed);
                analogWrite(speedRight, baseSpeed);
            }
        } 
        else if (command == allStop) {
            digitalWrite(motorLeft, LOW);
            digitalWrite(motorRight, LOW);

            if (useMotorEncoders)
                balanceSpeed();
            else {
                analogWrite(speedLeft, 0);
                analogWrite(speedRight, 0);
            }
            
            digitalWrite(augerCont, LOW);
        }
        else if (command == rightTurn) {  //Right
            digitalWrite(motorLeft, HIGH);
            digitalWrite(motorRight, LOW);

            if (useMotorEncoders)
                balanceSpeed();
            else {
                analogWrite(speedLeft, baseSpeed);
                analogWrite(speedRight, baseSpeed);
            }
        }
        else if (command == leftTurn) {  //Left
            digitalWrite(motorLeft, LOW);
            digitalWrite(motorRight, HIGH);

            if (useMotorEncoders)
                balanceSpeed();
            else {
                analogWrite(speedLeft, baseSpeed);
                analogWrite(speedRight, baseSpeed);
            }
        }
        else if (command == backward) {
            digitalWrite(motorLeft, HIGH);
            digitalWrite(motorRight, HIGH);

            if (useMotorEncoders)
                balanceSpeed();
            else {
                analogWrite(speedLeft, baseSpeed);
                analogWrite(speedRight, baseSpeed);
            }
        }
            
        //Auger Control
        else if (command == augerStart) {
            digitalWrite(augerCont, HIGH);
        }
        else if (command == augerStop) {
            digitalWrite(augerCont, LOW);
        }
            
        //Speed Control
        else if (command == "25") {
          rSpeed = lSpeed = baseSpeed = 64;
        }
        else if (command == "50") {
          rSpeed = lSpeed = baseSpeed = 130;
        }
        else if (command == "75") {
          rSpeed = lSpeed = baseSpeed = 190;
        }
        else if (command == "100") {
          rSpeed = lSpeed = baseSpeed = 250;
        }

        //E-Stop
        else if (command == recEStop) {
            analogWrite(speedLeft, 0);
            analogWrite(speedRight, 0);
            digitalWrite(motorLeft, LOW);
            digitalWrite(motorRight, LOW);
            digitalWrite(augerCont, LOW);

            while(1) {  //Freeze until all clear is recived
                if (Serial.available() > 0) {
                    String command = Serial.readStringUntil('\n');
                    if (command == recClear)
                        break;
                }
                delay(refreshRate);
            }
        }

        else {
            //Do nothing
        } 
    }
}

void sendUltrasonic() {
    String distLeft = String(readUltrasonic(trigLeft, echoLeft));
    String distRight = String(readUltrasonic(trigRight, echoRight));
    String distRear = String(readUltrasonic(trigRear, echoRear));
    Serial.println("R" + distRight);
    Serial.println("L" + distLeft);
    Serial.println("B" + distRear);
}

void checkBattLevels() {
    int raw12V = analogRead(battery12VPin);
    int raw40V = analogRead(battery40VPin);
    float voltage12V = (raw12V / (float)adcMax) * voltageReference;
    float voltage40V = (raw40V / (float)adcMax) * voltageReference;

    float actual12V = voltage12V / divRatio12V;
    float actual40V = voltage40V / divRatio40V;

    int per12V = (int)(100 * (actual12V - cut12V) / (nom12V - cut12V));
    int per40V = (int)(100 * (actual40V - cut40V) / (nom40V - cut40V));

    per12V = constrain(per12V, 0, 100);
    per40V = constrain(per40V, 0, 100);

    /*
    Serial.print("Raw 12V ADC: ");
    Serial.println(raw12V);
    Serial.print("Raw 40V ADC: ");
    Serial.println(raw40V);

    Serial.print("Voltage 12V: ");
    Serial.println(voltage12V, 2);
    Serial.print("Voltage 40V: ");
    Serial.println(voltage40V, 2);
    */

    Serial.println("P" + String(per12V));
    Serial.println("Q" + String(per40V));
}

void checkEStop() {
    if (digitalRead(eStopPin) == LOW) {  //E-Stop triggered
        analogWrite(speedLeft, 0);
        analogWrite(speedRight, 0);
        digitalWrite(motorLeft, LOW);
        digitalWrite(motorRight, LOW);
        digitalWrite(augerCont, LOW);

        Serial.println(sendEStop);
        
        while (1) {
            if (digitalRead(eStopPin) == HIGH) {
                Serial.println(sendClear);
                break;
            }
            delay(refreshRate);
        }
    } 
}

void loop() {
    if (takeSonicData)
        sendUltrasonic();
    
    if (listenForCommands)
        listenSerial();

    checkBattLevels();
    checkEStop();
    Serial.println(counter++);
    delay(refreshRate);
}
