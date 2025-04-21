//Setting the values for serial communication
const int serialBaudRate = 9600;
const int eStopPin = 13;

//Setting the values for the battery monitor pins
const int battery12VPin = A0;
const int battery40VPin = A1;
const float voltageReference = 5.0; // Arduino ADC reference (5V for most boards)
const int adcMax = 1023;            // 10-bit ADC resolution
const double nom40V = 40;
const double cut40V = 33;
const double res40Vtop = 91180;
const double res40Vbot = 4823.5;
const double nom12V = 12.8;
const double cut12V = 10;
const double res12Vtop = 40398;
const double res12Vbot = 20003;
const double divRatio40V = res40Vbot / (res40Vtop + res40Vbot);
const double divRatio12V = res12Vbot / (res12Vtop + res12Vbot);

// Motor and auger control pins
const int motorLeft = 12;
const int motorRight = 8;
const int speedLeft = 10;
const int speedRight = 11;
const int augerCont = 9;

// 
int baseSpeed = 150;

// Commands
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
const int refreshRate = 200;

// Ultrasonic sensor pins
const int trigLeft = 6;
const int echoLeft = 7;
const int trigRight = 2;
const int echoRight = 3;
const int trigRear = 4;
const int echoRear = 5;
int rSpeedMax = 255;
int lSpeedMax = 255;
int rSpeed = rSpeedMax;
int lSpeed = lSpeedMax;
float rspeedMultiplier = 1;
float lspeedMultiplier = 1;

// Flags
const bool takeSonicData = true;
const bool listenForCommands = true;
bool arduinoEStopActive = false;
bool jetsonEStopActive = false;

void setup() {
    Serial.begin(serialBaudRate);
    pinMode(eStopPin, INPUT_PULLUP);
    pinMode(motorLeft, OUTPUT);
    pinMode(motorRight, OUTPUT);
    pinMode(speedLeft, OUTPUT);
    pinMode(speedRight, OUTPUT);
    pinMode(augerCont, OUTPUT);
    pinMode(trigLeft, OUTPUT);
    pinMode(echoLeft, INPUT);
    pinMode(trigRight, OUTPUT);
    pinMode(echoRight, INPUT);
    pinMode(trigRear, OUTPUT);
    pinMode(echoRear, INPUT);
}

long readUltrasonic(int trigPin, int echoPin) {
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);
    long duration = pulseIn(echoPin, HIGH);
    long distance = duration * 0.034 / 2;
    return distance;
}

void sendUltrasonic(String &json) {
    String distLeft = String(readUltrasonic(trigLeft, echoLeft));
    String distRight = String(readUltrasonic(trigRight, echoRight));
    String distRear = String(readUltrasonic(trigRear, echoRear));
    json += "\"usL\":" + distLeft + ",";
    json += "\"usR\":" + distRight + ",";
    json += "\"usB\":" + distRear + ",";
}

void eStopActive(){
    analogWrite(speedLeft, 0);
    analogWrite(speedRight, 0);
    digitalWrite(motorLeft, LOW);
    digitalWrite(motorRight, LOW);
    digitalWrite(augerCont, LOW);
}

void checkBattLevels(String &json) {
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
    json += "\"per12\":" + String(per12V) + ",";
    json += "\"per40\":" + String(per40V);
}

void listenSerial() {
    if (Serial.available() > 0) {
        String command = Serial.readStringUntil('\n');

        // Always handle Jetson E-Stop and All Clear
        if (command == recEStop){
            jetsonEStopActive = true;
            eStopActive();
            return;
        }
        else if (command == recClear){
            jetsonEStopActive = false;
            return;
        }

        // Ignore other commands if Arduino E-stop is active
        if (arduinoEStopActive || jetsonEStopActive) return;

        if (command == forward) {
            digitalWrite(motorLeft, HIGH);
            digitalWrite(motorRight, LOW);
            analogWrite(speedLeft, lSpeed);
            analogWrite(speedRight, rSpeed);
        }
        else if (command == allStop) {
            digitalWrite(motorLeft, LOW);
            digitalWrite(motorRight, LOW);
            analogWrite(speedLeft, 0);
            analogWrite(speedRight, 0);
        }
        else if (command == rightTurn) {
            digitalWrite(motorLeft, LOW);
            digitalWrite(motorRight, LOW);
            analogWrite(speedLeft, lSpeed);
            analogWrite(speedRight, rSpeed);
        }
        else if (command == leftTurn) {
            digitalWrite(motorLeft, HIGH);
            digitalWrite(motorRight, HIGH);
            analogWrite(speedLeft, lSpeed);
            analogWrite(speedRight, rSpeed);
        }
        else if (command == backward) {
            digitalWrite(motorLeft, LOW);
            digitalWrite(motorRight, HIGH);
            analogWrite(speedLeft, lSpeed);
            analogWrite(speedRight, rSpeed);
        }
        else if (command == augerStart) {
            digitalWrite(augerCont, HIGH);
        }
        else if (command == augerStop) {
            digitalWrite(augerCont, LOW);
        }
        else if (command == "25") {
            rSpeed = rSpeedMax * 0.25 * rspeedMultiplier;
            lSpeed = lSpeedMax * 0.25 * lspeedMultiplier;
            baseSpeed = rSpeed;
        }
        else if (command == "50") {
            rSpeed = rSpeedMax * 0.50 * rspeedMultiplier;
            lSpeed = lSpeedMax * 0.50 * lspeedMultiplier;
            baseSpeed = rSpeed;
        }
        else if (command == "75") {
            rSpeed = rSpeedMax * 0.75 * rspeedMultiplier;
            lSpeed = lSpeedMax * 0.75 * lspeedMultiplier;
            baseSpeed = rSpeed;
        }
        else if (command == "100") {
            rSpeed = rSpeedMax * 1 * rspeedMultiplier;
            lSpeed = lSpeedMax * 1 * lspeedMultiplier;
            baseSpeed = rSpeed;
        }
    }
}

void checkArduinoEStop(String &json) {
    if(digitalRead(eStopPin) == LOW) {
        arduinoEStopActive = true;
        eStopActive();
        json += "\"arduinoEStop\":1,";
    } else {
        arduinoEStopActive = false;
        json += "\"arduinoEStop\":0,";
    }
}

void loop() {
    String json = "{";
    checkArduinoEStop(json);
    sendUltrasonic(json);
    checkBattLevels(json); 
    listenSerial();
    json += "}";
    Serial.println(json);
    delay(refreshRate);
}