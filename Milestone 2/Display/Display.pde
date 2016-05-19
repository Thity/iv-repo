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
QuadGraph qd = new QuadGraph();

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
  PImage imgOrig = loadImage("board3.jpg");
  imgOrig.resize(533, 400);
  imgOrig.updatePixels();
  
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
  
  noLoop();
}