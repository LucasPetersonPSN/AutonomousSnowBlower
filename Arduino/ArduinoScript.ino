//Setting the values for serial communication
const int serialBaudRate = 9600;
const int eStopPin = 13;

//Setting the values for the motor driver control pins nad the relay control pin
const int motorLeft = 8;  //TO DIR
const int motorRight = 12;  //TO DIR
const int speedLeft = 10;  //TO ENB
const int speedRight = 11;  //TO ENA
const int augerCont = 9;
const int leftEncoderPin = 2;   // Must be interrupt-capable
const int rightEncoderPin = 3;  // Must be interrupt-capable
volatile long leftECount = 0;
volatile long rightECount = 0;
long prevLeftEncoder = 0;
long prevRightEncoder = 0;
const int baseSpeed = 150;  //Default speed of motors before encoder adjustment, only when encoders are used
float Kp = 1.0;  //Proportional gain of encoder controller

//Setting the values for the motor driver queues **TROUBLESHOOT HERE**
const String forward = "Forward";
const String backward = "Backward";
const String leftTurn = "Left";
const String rightTurn = "Right";
const String allStop = "Stop";
const String augerStart = "GoAug";
const String augerStop = "CeaseAug";
const int refreshRate = 200;  //In miliseconds, has min of 50, max of 1000 (sensor limits)

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

    //Setting the motor driver control pins
    pinMode(motorLeft1, OUTPUT);
    pinMode(motorLeft2, OUTPUT);
    pinMode(motorRight1, OUTPUT);
    pinMode(motorRight2, OUTPUT);
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

void balanceMotors() {
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
    if (Serial.available()>0) {
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
        else if (command == augerStart) {
            digitalWrite(augerCont, LOW);
        }
            
        //Speed Control
        else if (command == "25"){
          rSpeed = lSpeed = baseSpeed = 64;
        }
        else if (command == "50"){
          rSpeed = lSpeed = baseSpeed = 130;
        }
        else if (command == "75"){
          rSpeed = lSpeed = baseSpeed = 190;
        }
        else if (command == "100"){
          rSpeed = lSpeed = baseSpeed = 250;
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

void loop() {
    if (takeSonicData)
        sendUltrasonic();
    
    if (listenForCommand)
        listenSerial();

    delay(refreshRate);
}
