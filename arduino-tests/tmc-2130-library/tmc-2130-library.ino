#include <TMC2130Stepper_REGDEFS.h>
#include <TMC2130Stepper.h>
#include <TMC2130Stepper_UTILITY.h>


#define EN_PIN    7 //enable (CFG6)
#define DIR_PIN   8 //direction
#define STEP_PIN  9 //step
#define CS_PIN   10 //chip select

bool running = false;
int dir = 1;

TMC2130Stepper TMC2130 = TMC2130Stepper(EN_PIN, DIR_PIN, STEP_PIN, CS_PIN);


void setup() {
  Serial.begin(115200);
  TMC2130.begin();
  TMC2130.SilentStepStick2130(1000);
  TMC2130.stealthChop(1);
  TMC2130.microsteps(8);

  digitalWrite(EN_PIN, LOW);
}

void loop() {

  if (Serial.available() > 0) {
    Serial.println("Reading");
    String msg = Serial.readStringUntil('\n');
    Serial.println("Read: " + msg);
    if (msg == "run") {
      running = true;
    } else if (msg == "stop") {
      running = false;
    }
  }

  if (running) {
    TMC2130.
    digitalWrite(STEP_PIN, HIGH);
    delayMicroseconds(100);
    digitalWrite(STEP_PIN, LOW);
    delayMicroseconds(100);
    uint32_t ms = millis();
    static uint32_t last_time = 0;
    if ((ms - last_time) > 2000) {
      if (dir) {
        Serial.println("Dir -> 0");
        TMC2130.shaft_dir(0);
      } else {
        Serial.println("Dir -> 1");
        TMC2130.shaft_dir(1);
      }
      dir = !dir;
      //Serial.println(TMC2130.GCONF(), BIN);
      last_time = ms;
    }
  }
}
