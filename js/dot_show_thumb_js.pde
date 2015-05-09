/* @pjs preload="fotos_small/anderson.png, fotos_small/calosci.png"; */

ArrayList <dot> Punti;
int squareTo;
PImage online;
String url;

int counter, maxCounter;
int vMode;

String[] images;

void setup(){
  size(324,324);
  frameRate(24);
  squareTo = 48; // img
  maxCounter = 24*3;
  vMode = 0; // 0 puntitos // 1: IMG
   
  // url = "http://www.negot.net/ahoraTU/fotos_small/anderson.png";
  online = loadImage("fotos_small/anderson.png");
  //online = requestImage(url);
  Punti = new ArrayList();
    
   for (int n = 0; n<(48*48); n++) {
    dot p = new dot(random(width), random(height), 5);
    Punti.add(p);
  }
  
  // riassign altro
  for (int n = 0; n<Punti.size (); n++) {
    dot p = Punti.get(n);    
    p.altro = int(random(Punti.size()));
  }
  
  
}

void draw(){
  background(0,165,141);
  
  // display dots
  noStroke();
  for (int n = 0; n<Punti.size (); n++) {
    dot p = Punti.get(n);
    p.display();
    p.update(n);
  }
  
  // counter
  counter ++;
  checkCounter();
  
}

void keyPressed() {
  if (key == 'a' ) {
    online = loadImage("fotos_small/anderson.png");
     imageDot();
  }
  
  if (key == 'z' ) {
    online = loadImage("fotos_small/calosci.png");
     imageDot();
  }
  
  if (key == ' ' ) {
     changeDotMode(0);
  }
}

void checkCounter(){
  if(counter > maxCounter){
    counter = 0;
   
   if(vMode == 0){
     // > img
     imageDot();
     maxCounter = 24*8;
   } else {
     // > random
      changeDotMode(0);
      vMode = 0;
      maxCounter = 24*2;
      
      // load a different image
      float R = random(1);
      if(R<0.5){
        online = loadImage("fotos_small/anderson.png");
      } else {
         online = loadImage("fotos_small/calosci.png");
      }
   }
    
    
  }
}


void imageDot() {
 PImage myFace_Canvas  = online.get(0,0,48,48);
  // assign x y and w
  float g = (height / squareTo); //  dot grid
  PVector centro = new PVector(width/2, height/2);

  int dotW = floor(myFace_Canvas.width * g);
  int dotH = floor(myFace_Canvas.height * g);

  float deltaX = centro.x - (dotW/2);
  float deltaY = centro.y - (dotH/2);
  
  int count = 0;

  for (int n = 0; n< myFace_Canvas.width; n++) {
    for (int i = 0; i< myFace_Canvas.height; i++) {

      color col = myFace_Canvas.get(n, i);
      float b = brightness(col);
      float w = map(b, 0, 255, 0, g);// diametro

      //float iX = deltaX + g + n*(g);
      //float iY = deltaY + g + i*(g);
      
      float iX = deltaX  + g/2+ n*(g);
      float iY = deltaY  + g/2 + i*(g);

      dot p = Punti.get(count);
      count ++;

      p.locTarget.x = iX;
      p.locTarget.y = iY;

      p.w_target = w;
      p.dMode = 1;
    }
  }
  vMode = 1;
}

void changeDotMode(int newMode) {
  for (int n = 0; n<Punti.size (); n++) {
    dot p = Punti.get(n);    
    p.dMode = newMode;
    p.altro = int(random(Punti.size()));
  }
 // println("change Dot mode to: " + newMode);
}


class dot {

  PVector loc; // dove
  PVector vel; // velocita

  PVector acc; // accellerazione
  float vMax; // velocitá massima

  float w, w_target; // dimensioni
  color c;

  int altro; // dot to follow
  int c_group; // cluster group
  int dMode; // display mode
  int iterationCounter;

  float gray, gray_target;

  PVector locTarget; // dove
  float easing = 0.05;

  // semantic
  String myType;
  int myNum; // index number in "Punti"
  String myText;
  String myId;

  boolean dotMode;

  dot(float _x, float _y, float _w) {

    loc = new PVector(_x, _y);
    locTarget = new PVector(_x, _y);

    vel = new PVector(0, 0);
    acc = new PVector(0.01, 0.03);

    w = _w;
    w_target = _w;
    c = color(255);

    vMax = random(2, 6);
    altro = 0;
    c_group = 0;
    dMode = 0;

    gray = 0;
    gray_target = 0;

    myType = "z";
    myNum = 0;
    myText = "";

    myId = "";
    dotMode = true;
  }

  void display() {
    // just drowing

    fill(c);
    ellipse(loc.x, loc.y, w, w);

    // size easing
    float dw = w_target - w;
    if (abs(dw) > 0.1) {
      w += dw * easing;
    }

    // gray easing
    float dg = gray_target - gray;
    if (abs(dg) > 0.1) {
      gray += dg * easing;
      c = color(gray);
    }
  }

  void update(int dotN) {
    // update loc values

    // follow mode
    if (dMode == 0) {
      // calcola la traiettoria
      dot altroPunto = Punti.get(altro);
      PVector altroV = new PVector(altroPunto.loc.x, altroPunto.loc.y);

      //distanza
      float d = altroV.dist(loc);

      if (loc.mag() > width) {
        // se sei troppo lontano vai verso il centro
        altroV = new PVector(width/2, height/2);
      } 

      if (d < 2) {
        // se sei arrivato cercane un altro
        altro = int(random(Punti.size()));
      } 

      acc = PVector.sub(altroV, loc);
      acc.normalize();
      acc.mult(0.5);

      vel.add(acc); // accellera
      vel.limit(vMax); // limite di velocita
      loc.add(vel);
    }

    // Loc easing to target
    if (dMode == 1) {
      float dx = locTarget.x - loc.x;
      if (abs(dx) > 0.1) {
        loc.x += dx * easing;
      }

      float dy = locTarget.y - loc.y;
      if (abs(dy) > 0.1) {
        loc.y += dy * easing;
      }
    }

    // packing
    if (dMode == 2) {
      // iterateLayout > overlap
      PVector v = new PVector();

      for (int i=dotN+1; i<Punti.size (); i++) {
        // the others dots 
        dot altroPunto = Punti.get(i);

        float dx = altroPunto.loc.x - loc.x;
        float dy = altroPunto.loc.y - loc.y;

        // distanza
        float d = (dx*dx) + (dy*dy);
        float r = (w_target/2 + altroPunto.w_target/2) +4;

        //if (d < (r * r) - 0.01 ) {
        if (d < (r * r)) {
          v.x = dx;
          v.y = dy;

          v.normalize();
         // v.mult((r-sqrt(d))*0.5);
          v.mult((r-sqrt(d))*0.2);
          altroPunto.loc.x += v.x;
          altroPunto.loc.y += v.y;

          loc.x -= v.x;
          loc.y -= v.y;
        }
      }

      // contract
      float damping = 0.2/float(iterationCounter);
      PVector centro = new PVector(width/2, height/2);

      v.x = loc.x-centro.x;
      v.y = loc.y-centro.y;
      v.mult(damping);

      loc.x -= v.x;
      loc.y -= v.y;

      iterationCounter ++;
    }
  }

  void colorizeMe() {
    char t = myType.charAt(0);

    switch(t) {
    case 'l': 
      gray_target = 255-200;
      break;
    case 'i': 
      gray_target = 255-120;
      break;
    case 'k': 
      gray_target = 255-96;
      break;
    case 'p': 
      gray_target = 255-180;
      break;
    default: 
      gray_target = 255-64; 
      break;
    }
  }

  void whiteMe() {
    gray_target = 0;
  }

  void grayMe() {
    gray_target = 255-64;
  }
}


