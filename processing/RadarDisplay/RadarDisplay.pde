import processing.serial.*;

Serial port;
String[] ports;
String portName = "";
String message = "Select your Arduino port";

volatile float angle = 90;
volatile float distance = -1;
volatile int lastReading = 0;
volatile int readingCount = 0;

int previousCount = 0;
ArrayList<Float> trail = new ArrayList<Float>();

final float MAX_CM = 40;
final float RADIUS = 380;

void setup() {
  size(1000, 740);
  smooth();
  textFont(createFont("Arial", 20));
  ports = Serial.list();
}

void draw() {
  background(4, 10, 14);

  fill(95, 255, 170);
  textSize(28);
  text("AIR RADAR", 35, 48);

  textSize(14);
  fill(125, 155, 155);
  text("ULTRASONIC SCANNER  /  LIVE VIEW", 35, 75);

  if (port == null) {
    drawPortMenu();
    return;
  }

  float currentAngle = angle;
  float currentDistance = distance;
  boolean fresh = lastReading > 0 &&
                  millis() - lastReading < 2000;
  boolean detected = fresh &&
                     currentDistance >= 2 &&
                     currentDistance <= MAX_CM;

  if (readingCount != previousCount) {
    trail.add(currentAngle);
    if (trail.size() > 24) trail.remove(0);
    previousCount = readingCount;
  }

  String rangeText = "--";
  if (fresh && currentDistance >= 0) {
    rangeText = nf(currentDistance, 0, 1) + " cm";
  }

  drawCard(35, "ANGLE", int(currentAngle) + " deg");
  drawCard(350, "DISTANCE", rangeText);
  drawCard(665, "STATUS",
    !fresh ? "WAITING" : detected ? "TARGET" : "SCANNING");

  pushMatrix();
  translate(width / 2, 640);

  // Radar rings and angle lines.
  strokeWeight(1);
  for (int cm = 10; cm <= 40; cm += 10) {
    float r = RADIUS * cm / MAX_CM;
    stroke(30, 115, 75);
    noFill();
    arc(0, 0, r * 2, r * 2, PI, TWO_PI);

    fill(95, 175, 130);
    textSize(13);
    textAlign(CENTER);
    text(cm + " cm", r - 25, 24);
  }

  for (int deg = 0; deg <= 180; deg += 30) {
    float a = radians(deg);
    stroke(22, 65, 48);
    line(0, 0,
      RADIUS * cos(a), -RADIUS * sin(a));

    fill(95, 175, 130);
    textSize(13);
    text(deg + "",
      (RADIUS + 24) * cos(a),
      -(RADIUS + 24) * sin(a));
  }

  // Fading sweep trail, based on received angles.
  if (fresh) {
    for (int i = 0; i < trail.size(); i++) {
      float a = radians(trail.get(i));
      float opacity = map(i, 0, trail.size(), 5, 95);
      stroke(50, 255, 140, opacity);
      strokeWeight(3);
      line(0, 0,
        RADIUS * cos(a), -RADIUS * sin(a));
    }

    float a = radians(currentAngle);
    stroke(120, 255, 185);
    strokeWeight(2);
    line(0, 0,
      RADIUS * cos(a), -RADIUS * sin(a));

    if (detected) {
      float r = RADIUS * currentDistance / MAX_CM;
      float x = r * cos(a);
      float y = -r * sin(a);

      noStroke();
      fill(255, 65, 90, 35);
      ellipse(x, y, 52, 52);

      pushMatrix();
      translate(x, y);
      rotate(HALF_PI - a);
      drawPlane();
      popMatrix();
    }
  }

  noStroke();
  fill(120, 255, 185);
  ellipse(0, 0, 10, 10);
  popMatrix();

  textAlign(LEFT);
  textSize(14);
  fill(125, 155, 155);
  text("PORT: " + portName + "  |  RANGE: 40 cm",
    35, 710);

  textAlign(RIGHT);
  fill(detected ? color(255, 100, 120) :
                     color(95, 210, 145));
  text(!fresh ? "WAITING FOR ARDUINO DATA" :
    detected ? "TARGET DETECTED" : "SCANNING",
    width - 35, 710);
  textAlign(LEFT);
}

void drawCard(float x, String label, String value) {
  stroke(25, 65, 55);
  strokeWeight(1);
  fill(9, 24, 25);
  rect(x, 105, 300, 85, 12);

  noStroke();
  fill(105, 155, 140);
  textSize(13);
  textAlign(LEFT);
  text(label, x + 18, 131);

  fill(170, 255, 205);
  textSize(25);
  text(value, x + 18, 169);
}

void drawPlane() {
  noStroke();
  fill(255, 75, 100);
  beginShape();
  vertex(0, -20);
  vertex(4, -7);
  vertex(20, 5);
  vertex(20, 10);
  vertex(4, 5);
  vertex(3, 13);
  vertex(9, 18);
  vertex(9, 21);
  vertex(0, 18);
  vertex(-9, 21);
  vertex(-9, 18);
  vertex(-3, 13);
  vertex(-4, 5);
  vertex(-20, 10);
  vertex(-20, 5);
  vertex(-4, -7);
  endShape(CLOSE);
}

void drawPortMenu() {
  textAlign(LEFT);
  fill(220, 245, 235);
  textSize(22);
  text("Choose your Arduino COM port", 55, 145);

  for (int i = 0; i < ports.length; i++) {
    float y = 175 + i * 48;
    stroke(35, 125, 85);
    fill(12, 40, 30);
    rect(55, y, 420, 38, 8);

    fill(155, 255, 195);
    textSize(18);
    text(ports[i], 75, y + 26);
  }

  noStroke();
  textSize(16);
  fill(255, 205, 125);
  text(message, 55, height - 85);

  fill(125, 155, 155);
  text("Connect USB. Press R to refresh ports.",
    55, height - 50);
}

void mousePressed() {
  if (port != null) return;

  for (int i = 0; i < ports.length; i++) {
    float y = 175 + i * 48;

    if (mouseX >= 55 && mouseX <= 475 &&
        mouseY >= y && mouseY <= y + 38) {
      try {
        port = new Serial(this, ports[i], 9600);
        portName = ports[i];
        port.clear();
        port.bufferUntil('\n');
      }
      catch (Exception e) {
        if (port != null) port.stop();
        port = null;
        message =
          "Cannot open port. Close Arduino Serial Monitor.";
      }
      break;
    }
  }
}

void keyPressed() {
  if (port == null && (key == 'r' || key == 'R')) {
    ports = Serial.list();
    message = "Select your Arduino port";
  }
}

void serialEvent(Serial p) {
  String line = p.readStringUntil('\n');
  if (line == null) return;

  String[] values = match(trim(line),
    "^Angle:\\s*(\\d+)\\s*\\|\\s*Distance:\\s*(.*)$");
  if (values == null) return;

  float newAngle = float(values[1]);
  String reading = trim(values[2]);
  float newDistance = -1;

  if (!reading.equals("No echo")) {
    newDistance = float(trim(reading.replace("cm", "")));
    if (Float.isNaN(newDistance)) return;
  }

  angle = newAngle;
  distance = newDistance;
  lastReading = millis();
  readingCount++;
}
