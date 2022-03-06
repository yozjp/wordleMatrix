#include "M5Atom.h"

void setup() {
    M5.begin(true, false, true);    //Init Atom-Matrix(Initialize serial port, LED matrix).  初始化 ATOM-Matrix(初始化串口、LED点阵)
    Serial.begin(115200);
    delay(50);
}

void loop() {
  if (Serial.available()) {
    char dat = Serial.read();
    if( dat != -1) {
      int x = (dat >> 5) & 7;
      int y = (dat >> 2) & 7;
      int col = dat & 3;
      switch(col) {
        case 1: // Yellow
          M5.dis.drawpix(x,y,0xffff00);
          break;
        case 2: // Green
          M5.dis.drawpix(x,y,0x00ff000);
          break;
        case 0: // Black
        default:
          M5.dis.drawpix(x,y,0x0000000);
      }
    }
  }
  delay( 5);
  M5.update();

}
