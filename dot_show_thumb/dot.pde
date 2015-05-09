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

