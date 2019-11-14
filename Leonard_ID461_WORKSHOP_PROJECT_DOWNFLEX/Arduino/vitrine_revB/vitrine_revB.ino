/* Arduino Connection 
 *  - Port 4 = PW sur le capteur
 *  - 5V = +5
 *  - GND = GND
 */


int pwDist = 0;    // valeur capteur ultrason
int inByte = 0;         // incoming serial byte

const int ultrasonicPin = 4;
long sensor, mm;

int easePwDist [ ] = {0,0,0,0,0,0,0,0,0,0};
double sommes = 0;
int easeValue = 0;
int inc = 0;



void setup() {
  pinMode(ultrasonicPin, INPUT);
  // start serial port at 9600 bps and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  establishContact();  // send a byte to establish contact until receiver responds

}


void loop() {
 
  if (Serial.available() > 0) {
    // get incoming byte:
   
    // lecture port analogique
     pwDist = pulseIn(ultrasonicPin, HIGH);
     
    // envoi de la valeur sur le port serie 
     inByte = Serial.read();
     if(inc >10) {
      inc=0;
     }

     easePwDist [inc] = pwDist;

     sommes = 0;
     for (int i =0;i<10;i++){
     sommes += easePwDist [i];
     }
     easeValue = floor(sommes/10);
 

     
   Serial.println(easeValue);
  }
inc++;
delay (10);
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("0");   // send an initial string
    delay(300);
  }
}
