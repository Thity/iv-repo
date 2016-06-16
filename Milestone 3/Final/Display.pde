/**
 * @file Display.pde
 * @brief Main class to display result
 *
 * @authors Pere Adell  
 *          Thierry Bossy
 *          Rafael Pizzarro
 * @date 06.05.2016
 */

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Random;

// for filtering lego board
private float minHue = 96;
private float maxHue = 144;
private float minSat = 100;
private float maxSat = 255;
private float minBri = 32;
private float maxBri = 149;
//private Capture cam;
private PImage img;

Convolution conv = new Convolution();
FilterColors filter = new FilterColors();
QuadGraph qg = new QuadGraph();

void settings() {
  size(1466, 400);
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
  print(imgOrig.width);
  imgOrig.resize(533, 400);
  imgOrig.updatePixels();
  print(imgOrig.width);

  img = filter.HSBFilter(imgOrig, minHue, maxHue, minSat, maxSat, minBri, maxBri);
  img = conv.gaussianBlur(img);
  img = conv.gaussianBlur(img);
  img = filter.transformToBW(img, 150, 255);
  img = conv.gaussianBlur(img);
  img = conv.gaussianBlur(img);

  PImage sobelImg = conv.sobel(img);
  Hough hough = new Hough();
  hough.hough(sobelImg);

  PImage houghImg = hough.houghImg();

  image(imgOrig, 0, 0);
  hough.drawBestLines(img);
  hough.drawIntersections();

  image(houghImg, 533, 0);
  image(sobelImg, 933, 0);

  // Finding best lines
  List<PVector> lines = hough.getBestLines();
  qg.build(lines, sobelImg.width, sobelImg.height);
  List<int[]> quads = qg.findCycles();

  for (int[] quad : quads) {
    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);
    // (intersection() is a simplified version of the
    // intersections() method you wrote last week, that simply
    // return the coordinates of the intersection between 2 lines)
    PVector c12 = qg.intersection(l1, l2);
    PVector c23 = qg.intersection(l2, l3);
    PVector c34 = qg.intersection(l3, l4);
    PVector c41 = qg.intersection(l4, l1);
    // Choose a random, semi-transparent colour
    Random random = new Random();
    if (qg.isConvex(c12, c23, c34, c41) && qg.validArea(c12, c23, c34, c41, 10000000, 0) && qg.nonFlatQuad(c12, c23, c34, c41)) {
      fill(color(min(255, random.nextInt(300)), 
        min(255, random.nextInt(300)), 
        min(255, random.nextInt(300)), 50));
      quad(c12.x, c12.y, c23.x, c23.y, c34.x, c34.y, c41.x, c41.y);
    }
  }

  noLoop();
}