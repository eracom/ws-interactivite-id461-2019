import processing.serial.*;     // import the Processing serial library
Serial myPort;                  // The serial port

boolean fileLoaded; 
ArrayList<PImage> listeDimages;
String sketchPath = "";
File dirImages;
int imageCount = 0;
int Cursor    = 0;
int processCursor = 0;
int beforCursor = 0;

void setup() {
  fullScreen(2);
  noCursor();
  printArray(Serial.list()); // listing des ports séries disponibles
  myPort = new Serial(this, Serial.list()[2], 9600); // je choisi le numéro 2 de ma liste, c'est différent pour chaque ordinateur
  myPort.bufferUntil('\n');
  myPort.write("A"); // envoi d'un premier caractère pour déclancher la connexion avec l'arduino
  listeDimages  = new ArrayList<PImage>(100); 
  sketchPath = sketchPath();
  checkFile(); // contrôle du nombre d'image
  loadFile(); // chargement des images
}

void draw() {
  background(255); // fond de couleur blanche (255)
  stroke(125);
  display(); // affichage des images
 
 
  fill(255,0,0); //couleur du texte
  textSize(30); //taille du texte
  text(processCursor,10,35); // numéro de l'image en cour a la position 10 35
  
}

void display() {
  
  processCursor = int(map(Cursor,830,20000,-50,300)); // modification de la valeur donnée par le capteur 
  //le capteur donne une valeur entre 830 et 12000 (millimètre)
  //nous voulons parcourir une suite d'image de 95 images.
  
  if(processCursor >imageCount-1){ //si nous n'avons pas assez d'image nous devons limité la valeur maximum
    processCursor = imageCount-1;
  }
  if(processCursor < 0){
    processCursor = 0;
  }
  image(listeDimages.get(processCursor), 0, 0); // affichage de l'image
}

void serialEvent(Serial myPort) { //quand il y a un évènement sur le port serie nous passons dans cette fonction
  // read the serial buffer:
 
  String myString = myPort.readStringUntil('\n'); //lecture de l'information jusqu'qu caractère \n (retour à la ligne)
  myString = trim(myString);
  Cursor=int(myString); // conversion de la suite de caractère en integer
  myPort.write("A"); // envoi d'un accusé de reception pour demander une nouvelle valeur
}

void checkFile() { //fonction de comptage d'image
  dirImages = new File(sketchPath+"/data/MAIN_COMPO/");
  String[] leftList = dirImages.list();
  imageCount = leftList.length-1;
  print(str(imageCount) + " image(s) ");
}

void loadFile() { //fonction de chargement des images
  for (int i = 0; i<imageCount; i++) {
    listeDimages.add(loadImage("MAIN_COMPO/thebeatles"+nf(i, 5)+".png"));   // charger les images du dossier images se nommant left + normalisation à 4 numero + .png
    println(i+1+"/"+imageCount+" images"); //
  }
  fileLoaded = true;
  println("loaded ! ");
}
