//Setting the values for serial communication
const int serialBaudRate = 9600;
char junk;
String inputString = "";

//Setting the values for the motor driver control pins
const int motorLeft1 = 8;  //TO IN1
const int motorLeft2 = 9;  //TO IN2
const int motorRight1 = 13;  //TO IN3
const int motorRight2 = 12;  //TO IN4
const int speedLeft = 10;  //TO ENB
const int speedRight = 11;  //TO ENA

//Setting the values for the motor driver queues **TROUBLESHOOT HERE**
const String forward = "F";
const String backward = "B";
const String leftTurn = "L";
const String rightTurn = "R";
const String allStop = "S";
const int refreshRate = 200;  //In miliseconds, has min of 50, max of 1000 (sensor limits)

//Setting the values for the ultrasonic sensor control pins
const int trigLeft = 6;
const int echoLeft = 7;
const int trigRight = 2;
const int echoRight = 3;
const int trigRear = 4;
const int echoRear = 5;

bool stringComplete = false;

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
    
    if (Serial.available()) {
        inputString = "";
        stringComplete = false;
        bool stringComplete = false;
        
        while (Serial.available()) {
            char inChar = (char)Serial.read(); // Read the input character
  
            if (inChar == '\n')  // Check for newline (end of string)
                stringComplete = true;
            else
                inputString += inChar; // Append character to input string
        }
        
        Serial.println(inputString);
        Serial.println(inputString);
        
        while (Serial.available() > 0)
            junk = Serial.read(); // Clear the serial buffer

        //FORWARD
        if (inputString == forward) {  // FORWARD
            digitalWrite(motorLeft1, HIGH);
            digitalWrite(motorLeft2, LOW); // M1 Forward
            digitalWrite(motorRight1, LOW);
            digitalWrite(motorRight2, HIGH); // M2 Forward
            analogWrite(speedLeft, 255); // M1 Speed
            analogWrite(speedRight, 255); // M2 Speed
        } 
        //STOP
        else if (inputString == allStop) {  // STOP
            digitalWrite(motorLeft1, LOW);
            digitalWrite(motorLeft2, LOW); // M1 OFF
            digitalWrite(motorRight1, LOW);
            digitalWrite(motorRight2, LOW); // M2 OFF
        }
        //TURN RIGHT
        else if (inputString == rightTurn) {  // RIGHT TURN
            digitalWrite(motorLeft1, HIGH);
            digitalWrite(motorLeft2, LOW); // M1 Reverse, turn right
            digitalWrite(motorRight1, HIGH);
            digitalWrite(motorRight2, LOW); // M2 Forward, turn right
            analogWrite(speedLeft, 200); // M1 Speed
            analogWrite(speedRight, 200); // M2 Speed
        }
        //TURN LEFT
        else if (inputString == leftTurn) {  // LEFT TURN
            digitalWrite(motorLeft1, LOW);
            digitalWrite(motorLeft2, HIGH); // M1 Forward, turn left
            digitalWrite(motorRight1, LOW);
            digitalWrite(motorRight2, HIGH); // M2 Reverse, turn left
            analogWrite(speedLeft, 200); // M1 Speed
            analogWrite(speedRight, 200); // M2 Speed
        }
        //BACKWARDS
        else if (inputString == backward) {  // BACKWARDS
            digitalWrite(motorLeft1, LOW);
            digitalWrite(motorLeft2, HIGH); // M1 Reverse
            digitalWrite(motorRight1, HIGH);
            digitalWrite(motorRight2, LOW); // M2 Reverse
            analogWrite(speedLeft, 255); // M1 Speed
            analogWrite(speedRight, 255); // M2 Speed
        }
    }
    delay(refreshRate);
}
