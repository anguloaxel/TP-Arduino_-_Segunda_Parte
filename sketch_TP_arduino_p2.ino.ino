/* ============================================================
TP - Arduino Parte 2
============================================================ */

// Estados de entradas y salidas
const int entrada1 = 2;
const int entrada2 = 3;

// Buffer para recibir datos por Serial
const int salida1 = 8;
const int salida2 = 9;

int e1 = 0, e2 = 0;
int s1_manual = 0, s2_manual = 0;
int s1_final = 0, s2_final = 0;

String inputString = "";
bool stringComplete = false;

void setup() {
  Serial.begin(9600);

  // Pulsadores
  pinMode(entrada1, INPUT_PULLUP);
  pinMode(entrada2, INPUT_PULLUP);

  //Leds
  pinMode(salida1, OUTPUT);
  pinMode(salida2, OUTPUT);
}

void loop() {
  // Leer entradas
  e1 = !digitalRead(entrada1);
  e2 = !digitalRead(entrada2);

  // Estado final del LED = OR físico + manual
  s1_final = (s1_manual || e1);
  s2_final = (s2_manual || e2);

  // Aplicar LED
  digitalWrite(salida1, s1_final);
  digitalWrite(salida2, s2_final);

  // Enviar entradas
  Serial.print("E:");
  Serial.print(e1);
  Serial.print(",");
  Serial.println(e2);

  // Enviar estado final de los LEDs
  Serial.print("F:");
  Serial.print(s1_final);
  Serial.print(",");
  Serial.println(s2_final);

  // Procesar comandos PC
  if (stringComplete) {
    procesarComando(inputString);
    inputString = "";
    stringComplete = false;
  }

  delay(50);
}

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char) Serial.read();
    if (inChar == '\n') stringComplete = true;
    else inputString += inChar;
  }
}

void procesarComando(String cmd) {
 
  // Verifica si el comando comienza con "S:"
  // Esto indica que lo que viene son 2 valores de salida separados por coma.
  
  if (cmd.startsWith("S:")) {
    cmd.remove(0, 2); //Elimina los primeros dos caracteres "S:"
    int coma = cmd.indexOf(','); //Buscaposición de la coma

    s1_manual = cmd.substring(0, coma).toInt(); //Se extraen valores
    s2_manual = cmd.substring(coma + 1).toInt();
  }
}

