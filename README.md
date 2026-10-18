Arduino Radar ✈️ | رادار الأردوينو

An ultrasonic scanner built with Arduino Uno, an HC-SR04 sensor, and an SG90 servo, with a radar interface in Processing.

مشروع ماسح مسافة باستخدام الأردوينو وحساس HC-SR04 ومحرك SG90، مع واجهة رادار ببرنامج Processing.

How It Works | فكرة المشروع

The servo sweeps the sensor between 30° and 150°. Arduino sends angle and distance readings to Processing. A red airplane icon appears when an object is detected within 2–40 cm.

يحرك السيرفو الحساس بين 30 و150 درجة. يرسل الأردوينو الزاوية والمسافة إلى Processing، وتظهر طائرة حمراء عند اكتشاف جسم ضمن 2–40 سم.

The airplane is a display symbol. The sensor measures distance; it does not identify aircraft or object types.

الطائرة رمز للعرض؛ الحساس يقيس المسافة ولا يحدد نوع الجسم.

Components | القطع

* Arduino Uno R3 — الأردوينو
* HC-SR04 ultrasonic sensor — حساس المسافة
* SG90 servo motor — محرك السيرفو
* Breadboard — لوحة التجارب
* Jumper wires — أسلاك التوصيل
* USB cable and computer — سلك USB وكمبيوتر

Wiring | التوصيلات

Component / القطعة	Pin / الطرف	Arduino / التوصيل
HC-SR04	VCC	5V
HC-SR04	GND	GND
HC-SR04	Trig	D10
HC-SR04	Echo	D11
SG90	Orange / برتقالي	D9
SG90	Red / أحمر	5V
SG90	Brown / بني	GND

Disconnect USB before changing any wiring. Keep the sensor’s movement path clear and leave slack in the wires.

افصل USB قبل تعديل التوصيلات، واترك مساحة لحركة الحساس والأسلاك.

Project Files | ملفات المشروع

* arduino/Radar/Radar.ino — Arduino control and distance measurement / التحكم بالحركة وقياس المسافة.
* processing/RadarDisplay/RadarDisplay.pde — Radar interface / واجهة الرادار.

Software | البرامج

* Arduino IDE with the Servo library — برنامج الأردوينو ومكتبة Servo.
* Processing in Java mode with the Serial library — برنامج Processing بوضع Java ومكتبة Serial.

Run the Project | تشغيل المشروع

1. Open Radar.ino in Arduino IDE.
    افتح ملف Radar.ino في برنامج الأردوينو.
2. Select Arduino Uno and its COM port, then upload the code.
    اختر Arduino Uno ومنفذه، ثم ارفع الكود.
3. Close Arduino Serial Monitor before connecting Processing.
    أغلق Serial Monitor قبل توصيل Processing بالمنفذ.
4. Open RadarDisplay.pde in Processing, select Java mode, and click Run.
    افتح RadarDisplay.pde في Processing بوضع Java واضغط تشغيل.
5. Select the Arduino COM port in the radar window.
    اختر منفذ الأردوينو في نافذة الرادار.
6. Place an object 10–30 cm in front of the sensor to test detection.
    ضع جسمًا أمام الحساس على بعد 10–30 سم لتجربة الكشف.

Serial speed / سرعة الاتصال: 9600 baud
Displayed detection range / مدى الكشف المعروض: 2–40 cm
Sweep angles / زوايا المسح: 30°–150°
