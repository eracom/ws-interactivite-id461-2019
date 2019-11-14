import processing.serial.*;     // import the Processing serial library
Serial myPort;                  // The serial port

boolean fileLoaded; 
ArrayList<PImage> listeDimages1;
ArrayList<PImage> listeDimages2;
String sketchPath = "";
File dirImages1;
File dirImages2;
int imageCount1 = 0;
int imageCount2 = 0;
int Cursor    = 0;
int processCursor = 0;
int beforCursor = 0;
boolean side = true;

void setup() {
  //size(1920, 1080); //taille de la fenêtre
  fullScreen(2);
  printArray(Serial.list()); // listing des ports séries disponibles
  myPort = new Serial(this, Serial.list()[6], 9600); // je choisi le numéro 2 de ma liste, c'est différent pour chaque ordinateur
  myPort.bufferUntil('\n');
  myPort.write("A"); // envoi d'un premier caractère pour déclancher la connexion avec l'arduino
  listeDimages1  = new ArrayList<PImage>(200); 
  listeDimages2  = new ArrayList<PImage>(200); 
  sketchPath = sketchPath();
  checkFile(); // contrôle du nombre d'image
  loadFile(); // chargement des images
}

void draw() {
  background(255); // fond de couleur noir (255)
  stroke(125);
  display(); // affichage des images
 
 
  fill(255,0,0); //couleur du texte
  textSize(30); //taille du texte
  text(processCursor,10,35); // numéro de l'image en cour a la position 10 35
  
}

void display() {
  
  processCursor = int(map(Cursor,830,12000,-50,255)); // modification de la valeur donnée par le capteur 
  //le capteur donne une valeur entre 830 et 12000 (millimètre)
  //nous voulons parcourir une suite d'image de 95 images.
  
   if(processCursor < 0){
      processCursor = 0;
    }
  if(processCursor == 0 ){
    side = false;
  }
  if(side == false && processCursor >= imageCount2-1){
    side = true;
  }
  if(side){
    if(processCursor >imageCount1-1){ //si nous n'avons pas assez d'image nous devons limité la valeur maximum
      processCursor = imageCount1-1;
    } 
    image(listeDimages1.get(processCursor), 0, 0); // affichage de l'image
  }else{
    if(processCursor >imageCount2-1){ //si nous n'avons pas assez d'image nous devons limité la valeur maximum
      processCursor = imageCount2-1;
    }
    image(listeDimages2.get(processCursor), 0, 0); // affichage de l'image
  }
  
}

void serialEvent(Serial myPort) { //quand il y a un évènement sur le port serie nous passons dans cette fonction
  // read the serial buffer:
 
  String myString = myPort.readStringUntil('\n'); //lecture de l'information jusqu'qu caractère \n (retour à la ligne)
  myString = trim(myString);
  Cursor=int(myString); // conversion de la suite de caractère en integer
  myPort.write("A"); // envoi d'un accusé de reception pour demander une nouvelle valeur
}

void checkFile() { //fonction de comptage d'image
  dirImages1 = new File(sketchPath+"/data/img/");
  String[] leftList1 = dirImages1.list();
  imageCount1 = leftList1.length-1;
  print(str(imageCount1) + " image(s) ");
  
  dirImages2 = new File(sketchPath+"/data/burnt2/");
  String[] leftList2 = dirImages2.list();
  imageCount2 = leftList2.length-1;
  print(str(imageCount2) + " image(s) ");
  
}

void loadFile() { //fonction de chargement des images
  for (int i = 0 ; i<imageCount1; i++) {
    listeDimages1.add(loadImage("img/banger"+nf(i, 5)+".png"));   // charger les images du dossier images se nommant left + normalisation à 4 numero + .png
    println(i+1+"/"+imageCount1+" images petard"); //    
  }
  
  for (int i = 0; i<imageCount2; i++) {
    listeDimages2.add(loadImage("burnt2/bangerz"+nf(i, 5)+".png"));   // charger les images du dossier images se nommant left + normalisation à 4 numero + .png
    println(i+1+"/"+imageCount2+" images suite "); // 
  }
fileLoaded = true;
println("loaded ! ");
}
