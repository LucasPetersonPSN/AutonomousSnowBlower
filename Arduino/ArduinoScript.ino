//Setting the values for serial communication
const int serialBaudRate = 9600;

//Setting the values for the motor driver control pins nad the relay control pin
const int motorLeft = 8;  //TO IN1 **CHANGE
const int motorRight = 12;  //TO IN4 **CHANGE
const int speedLeft = 10;  //TO ENB
const int speedRight = 11;  //TO ENA
const int augerCont = 9;

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
const int trigRight = 2;
const int echoRight = 3;
const int trigRear = 4;
const int echoRear = 5;
int rSpeed = 0;
int lSpeed = 0;

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

    //Setting the ultrasonic sensor control pins
    pinMode(trigLeft, OUTPUT);
    pinMode(echoLeft, INPUT);
    pinMode(trigRight, OUTPUT);
    pinMode(echoRight, INPUT);
    pinMode(trigRear, OUTPUT);
    pinMode(echoRear, INPUT);

    analogWrite(speedLeft, lSpeed);
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

void loop() {
    
    String distLeft = String(readUltrasonic(trigLeft, echoLeft));
    String distRight = String(readUltrasonic(trigRight, echoRight));
    String distRear = String(readUltrasonic(trigRear, echoRear));
    Serial.println(distLeft + "/" + distRight + "/" + distRear + "-");  //ASCII 47 47 45
    
    if (Serial.available()>0) {
        String command = Serial.readStringUntil('\n');

        //FORWARD
        if (command == forward) {  // FORWARD
            digitalWrite(motorLeft, LOW);
            digitalWrite(motorRight, LOW); // M2 Forward
            analogWrite(speedLeft, lSpeed); // M1 Speed
            analogWrite(speedRight, rSpeed); // M2 Speed
        } 
        //STOP
        else if (command == allStop) {  // STOP
            digitalWrite(motorLeft, LOW);
            digitalWrite(motorRight, LOW); // M2 OFF
            analogWrite(speedLeft, 0);
            analogWrite(speedRight, 0);
            digitalWrite(augerCont, LOW);
        }
        //TURN RIGHT
        else if (command == rightTurn) {  // RIGHT TURN
            digitalWrite(motorLeft, HIGH);
            digitalWrite(motorRight, LOW); // M2 Forward, turn right
            analogWrite(speedLeft, lSpeed); // M1 Speed
            analogWrite(speedRight, lSpeed); // M2 Speed
        }
        //TURN LEFT
        else if (command == leftTurn) {  // LEFT TURN
            digitalWrite(motorLeft, LOW);
            digitalWrite(motorRight, HIGH); // M2 Reverse, turn left
            analogWrite(speedLeft, lSpeed); // M1 Speed
            analogWrite(speedRight, rSpeed); // M2 Speed
        }
        //BACKWARDS
        else if (command == backward) {  // BACKWARDS
            digitalWrite(motorLeft, HIGH);
            digitalWrite(motorRight, HIGH); // M2 Reverse
            analogWrite(speedLeft, lSpeed); // M1 Speed
            analogWrite(speedRight, rSpeed); // M2 Speed
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
          rSpeed = lSpeed = 64;
        }
        else if (command == "50"){
          rSpeed = lSpeed = 130;
        }
        else if (command == "75"){
          rSpeed = lSpeed = 190;
        }
        else if (command == "100"){
          rSpeed = lSpeed = 250;
        }
        else {
            
        } 
    }
    delay(refreshRate);
}
