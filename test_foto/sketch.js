var img;  // Declare variable 'img'.
var img2
var squareTo = 48;
var imgW = 480;

function preload() {  // preload() runs once
   //img = loadImage("../fotos/m_anderson foto.jpg");  // Load the image 
   img = loadImage("../fotos/me_square.jpg");  // Load the image 
   
}

function setup() {
   createCanvas(800, 480);
   frameRate(24); 

   img2 = createImage(squareTo, squareTo);
   img2.loadPixels();

  for(var x = 0; x < img2.width; x++) {
    for(var y = 0; y < img2.height; y++) {
      img2.set(x, y, [0, 153, 204, 255]); 
    }
  }

  img2.updatePixels();

}

function draw() {
  background(0,165,141);
  image(img, 8, 8, 240,240);

  image(img2, 8, 240+8+8);

  stroke(255);
  //noFill();

  //fill(0,165,141);
  //rect(320 +8, 0+8, 400,400);

  // widt 400
  // 48 muestras

  var w = imgW/squareTo;
  fill(255);
  noStroke();

   img2.loadPixels();

  for (var n = 0; n< squareTo; n++) {
    for (var i = 0; i< squareTo; i++) {

    	var dX = w/2 + 320 + (i*w);
        var dY = w/2 + (n*w);
		

		var cX = 8 + (i*5);
		var cY = 8 + (n*5);

		var c = get(cX,cY);
		var cc = color(c);
		var b = brightness(cc);

 		//var c = get(floor(8+(i*5)), floor(8+(n*5));
     	// var cc = color(c);
     	// var b = brightness(cc);
     	 var s = map(b, 0,255, 1,w);

        ellipse(dX, dY, s,s);

        img2.set(i, n, [b, b, b, 255]); 
    }
	}

	img2.updatePixels();
}


  

