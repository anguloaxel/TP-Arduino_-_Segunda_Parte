/* ============================================================
   TP ARDUINO - Parte 2
   ============================================================ */

import processing.serial.*;

Serial myPort;

// Entradas desde Arduino
boolean entrada1 = false;
boolean entrada2 = false;

// Estado MANUAL enviado a Arduino
boolean salida1_manual = false;
boolean salida2_manual = false;

// Estado REAL del LED (mezcla física + manual)
boolean salida1_real = false;
boolean salida2_real = false;

int e1x = 150, e1y = 80;
int e2x = 300, e2y = 80;
int s1x = 150, s1y = 220;
int s2x = 300, s2y = 220;

void setup() {
  size(500, 350);

  println(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  background(220);
  textAlign(CENTER);
  textSize(20);

  text("ENTRADAS", 250, 40);
  text("SALIDAS", 250, 150);

  // Entradas desde Arduino
  dibujarCuadro(e1x, e1y, "E1", entrada1);
  dibujarCuadro(e2x, e2y, "E2", entrada2);

  // Salidas: se muestran con el estado real enviado por Arduino
  dibujarCuadro(s1x, s1y, "S1", salida1_real);
  dibujarCuadro(s2x, s2y, "S2", salida2_real);
}

void dibujarCuadro(int x, int y, String label, boolean estado) {
  fill( estado ? color(0,200,0) : color(200,0,0) );
  rectMode(CENTER);
  rect(x, y, 80, 50, 10);

  fill(0);
  text(label, x, y + 5);
}

// ------------------------------------------------------------
// CLICK DEL MOUSE PARA ENVIAR ESTADO MANUAL
// ------------------------------------------------------------
void mousePressed() {
  if (dist(mouseX, mouseY, s1x, s1y) < 40) {
    salida1_manual = !salida1_manual;
    enviarSalidas();
  }

  if (dist(mouseX, mouseY, s2x, s2y) < 40) {
    salida2_manual = !salida2_manual;
    enviarSalidas();
  }
}

void enviarSalidas() {
  String msg = "S:" + (salida1_manual?1:0) + "," + (salida2_manual?1:0) + "\n";
  myPort.write(msg);
  println("TX → " + msg);
}

// ------------------------------------------------------------
// LECTURA DEL PUERTO SERIE
// ------------------------------------------------------------
void serialEvent(Serial p) {
  String data = trim(p.readString());

  // Lectura entradas
  if (data.startsWith("E:")) {
    data = data.substring(2);
    int c = data.indexOf(',');
    entrada1 = data.substring(0,c).equals("1");
    entrada2 = data.substring(c+1).equals("1");
  }

  // Lectura de estado real del LED
  if (data.startsWith("F:")) {
    data = data.substring(2);
    int c = data.indexOf(',');
    salida1_real = data.substring(0,c).equals("1");
    salida2_real = data.substring(c+1).equals("1");
  }
}
