ArrayList <dot> Punti;
int squareTo;

String[] images;

void setup(){
  size(324,324);
  frameRate(24);
   squareTo = 48; // img
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
}


