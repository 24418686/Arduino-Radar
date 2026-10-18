#include <Servo.h>

Servo radarServo;

const byte SERVO_PIN = 9;
const byte TRIG_PIN = 10;
const byte ECHO_PIN = 11;

int angle = 90;
int direction = 1;

float measureDistance() {
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  unsigned long duration = pulseIn(ECHO_PIN, HIGH, 30000UL);

  if (duration == 0) {
    return -1;
  }

  return duration * 0.0343f / 2.0f;
}

void setup() {
  Serial.begin(9600);

  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  digitalWrite(TRIG_PIN, LOW);

  radarServo.attach(SERVO_PIN);
  radarServo.write(angle);
  delay(500);
}

void loop() {
  radarServo.write(angle);
  delay(70);

  float distance = measureDistance();

  Serial.print("Angle: ");
  Serial.print(angle);
  Serial.print(" | Distance: ");

  if (distance < 0) {
    Serial.println("No echo");
  } else {
    Serial.print(distance, 1);
    Serial.println(" cm");
  }

  if (angle >= 150) {
    direction = -1;
  } else if (angle <= 30) {
    direction = 1;
  }

  angle += direction;
}
