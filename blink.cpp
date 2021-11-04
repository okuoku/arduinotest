#include <Arduino.h>

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
}

//
extern "C"{
    void _exit(int bogus){(void)bogus;}
    void _kill(void){}
    int _getpid(void){return 1;}
}
