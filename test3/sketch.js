var capture;
var squareTo = 48;
var img;

function setup() {
  createCanvas(800, 480);
  capture = createCapture(VIDEO);
  capture.size(320, 240);
  capture.hide();

  frameRate(24);
  
  img = createImage(240, 240);
  img.loadPixels();

  for (i = 0; i < img.width; i++) {
    for (j = 0; j < img.height; j++) {
      img.set(i, j, color(0, 90, 102));
    }
  }
  img.updatePixels();
}

function draw() {
  background(255);
  image(capture, 0, 0, 320, 240);
  //image(img, 320, 0);
  
  // recuadro central
  img = get(40, 0,240,240);
  image(img,40,240);


  for (var n = 0; n< img.width; n+= 5) {
    for (var i = 0; i< img.height; i+= 5) {
      // color
      var c = get(40+i, 240+n);
      var cc = color(c);
      var b = brightness(cc);

      var dX = 320 + n*10;
      var dY = i*10;

      var s = map(b, 0,255, 1,20);

      fill(0);
      ellipse(dX, dY, s,s);
    }
  }


}
