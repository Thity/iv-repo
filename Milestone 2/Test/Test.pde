
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Arrays;
import java.util.ArrayList;

// for filtering lego board
private float minHue = 90;
private float maxHue = 145;
private float minSat = 110;
private float maxSat = 255;
private float minBri = 40;
private float maxBri = 170;
//private Capture cam;
private PImage img;

Convolutione conv = new Convolutione();
FilterColors filter = new FilterColors();
QuadGraph qd = new QuadGraph();

void settings() {
  size(1600, 900);
}

void setup() {
  /*
  //Camera
   String[] cameras = Capture.list();
   if (cameras.length == 0) {
   println("There are no cameras available for capture.");
   exit();
   } else {
   println("Available cameras:");
   for (int i = 0; i < cameras.length; i++) {
   println(cameras[i]);
   }
   cam = new Capture(this, cameras[0]);
   cam.start();
   }
   */
   noLoop();
}

void draw() {    
  //  if (cam.available() == true) {
  //    cam.read();
  //  }
  //  img = cam.get();
  PImage imgOrig = loadImage("board2.jpg");
  img = filter.HSBFilter(imgOrig, minHue, maxHue, minSat, maxSat, minBri, maxBri);
  img = conv.gaussianBlur(img);
  img = conv.gaussianBlur(img);
  img = filter.transformToBW(img, 150, 255);
  img = conv.gaussianBlur(img);
  img = filter.transformToBW(img, 150, 255);
  img = conv.gaussianBlur(img);
  PImage imgFinal = conv.sobel(img);
  

  Hough hugh = new Hough();
  hugh.hough(imgFinal);
  image(imgFinal, 800, 0);
  image(imgOrig, 0, 0);
    image(hugh.houghImg(), 400, 0);

  //hugh.plotLines(img);
  hugh.drawBestLines(img);
  hugh.drawIntersections();
  noLoop();
}