/**
 * @file FinalGame.pde
 * @brief Game with a pad and a ball
 *
 * @authors Pere Adell  
 *          Thierry Bossy
 *          Rafael Pizzarro
 * @date 29.03.2016
 */

import processing.video.*;
// Windows
final static int WINDOW_WIDTH = 1100;
final static int WINDOW_HEIGHT = 700;

void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT, P3D);
}

// Box
private final static int boxSide = 400;
private final static int boxX = boxSide;
private final static int boxY = 15;
private final static int boxZ = boxSide;
private final static int boxCenterX = WINDOW_WIDTH/2;
private final static int boxCenterY = 2*WINDOW_HEIGHT/5;
private Dashboard dashboard;
private Movie cam;
private TwoDThreeD twoToThree;

// For image
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
Hough hough = new Hough();
private int frames;

//Mouse

// Classes


void setup() {
  frames = 0;
  cam = new Movie(this, "testvideo.mp4");
  cam.loop();
  twoToThree = new TwoDThreeD(WINDOW_WIDTH, WINDOW_HEIGHT);
  noStroke();
  setupCylinderShapes();
  dashboard = new Dashboard();
  ball = new Mover(-boxX / 2, boxX / 2, -boxZ / 2, boxZ / 2, radiusBall, dashboard);
}


//The rotation of the box.
private float rx = 0;
private float rz = 0;
private float speed = 1;

void draw() {
  frames++;
  background(255);
  lights();
  fill(200);

  // The Object Placement Mode when the shift is pressed and otherwise the Game Mode.

  if (!shift) {

    dashboard.runScore();
    pushMatrix();

    translate(boxCenterX, boxCenterY, 0);
    rotateX(rx);
    rotateZ(rz);
    box(boxX, boxY, boxZ);     
    drawCylinders();    
    translate(ball.location.x, -ballOffset, -ball.location.y);
    ball.update(rx, rz);
    ball.display();
    ball.checkEdges();
  } else {
    dashboard.pauseScore();
    pushMatrix();
    translate(boxCenterX, boxCenterY, 0);
    rotateX(-PI/2);
    box(boxX, boxY, boxZ);    
    drawCylinders();
    translate(ball.location.x, -ballOffset, -ball.location.y);
    ball.display();
    if (mouseClick) {
      if (checkCylindersBox() && checkCylindersBall() && checkCylindersCylinders())
        addCylinder();
    }
    mouseClick = false;
  }
  popMatrix();
  fill(255, 255, 255);
  dashboard.drawAll();
  /* Image processing to get quads and move board */
  if (frames % 10 == 0) {
    img = cam.get();
    img = filter.HSBFilter(img, minHue, maxHue, minSat, maxSat, minBri, maxBri);
    img = conv.gaussianBlur(img);
    img = conv.gaussianBlur(img);
    img = filter.transformToBW(img, 150, 255);
    img = conv.gaussianBlur(img);
    img = conv.gaussianBlur(img);
    img = conv.sobel(img);
    hough.hough(img);
    List<PVector> lines = hough.getBestLines();
    qg.build(lines, img.width, img.height);
    List<int[]> quads = qg.findCycles();
    if (!quads.isEmpty()) {
      int[] bestQuad = findBestQuad(quads, lines);
      /* Draw Quad */
      /* Get corners */
      List<PVector> corners = new ArrayList<PVector>();

      corners.add(lines.get(bestQuad[0]));
      corners.add(lines.get(bestQuad[1]));
      corners.add(lines.get(bestQuad[2]));
      corners.add(lines.get(bestQuad[3]));
      // (intersection() is a simplified version of the
      // intersections() method you wrote last week, that simply
      // return the coordinates of the intersection between 2 lines)
      PVector c12 = qg.intersection(corners.get(0), corners.get(1));
      PVector c23 = qg.intersection(corners.get(1), corners.get(2));
      PVector c34 = qg.intersection(corners.get(2), corners.get(3));
      PVector c41 = qg.intersection(corners.get(3), corners.get(0));
      // Choose a random, semi-transparent colour
      Random random = new Random();
      if (qg.isConvex(c12, c23, c34, c41) && qg.validArea(c12, c23, c34, c41, 10000000, 0) && qg.nonFlatQuad(c12, c23, c34, c41)) {
        fill(color(min(255, random.nextInt(300)), 
          min(255, random.nextInt(300)), 
          min(255, random.nextInt(300)), 50));
        quad(c12.x, c12.y, c23.x, c23.y, c34.x, c34.y, c41.x, c41.y);
      }
      /* Get rotation */
      PVector rot = twoToThree.get3DRotations(corners);
      rot.x = (rot.x > Math.PI/2) ? (float) (rot.x - Math.PI) : rot.x;
      rot.x = (rot.x < -Math.PI/2) ? (float) (rot.x + Math.PI) : rot.x;      
      rx = rot.x;
      rz = rot.y;
    }
  }
}

public int[] findBestQuad(List<int[]> quads, List<PVector> lines) {
  float maxArea = 0;
  int maxIdx = 0;
  float i1;
  float i2;
  float i3;
  float i4;
  PVector c1, c2, c3, c4;
  int i = 0;
  for (int[] quad : quads) {
    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);
    c1 = qg.intersection(l1, l2);
    c2 = qg.intersection(l2, l3);
    c3 = qg.intersection(l3, l4);
    c4 = qg.intersection(l4, l1);

    i1=c1.cross(c2).z;
    i2=c2.cross(c3).z;
    i3=c3.cross(c4).z;
    i4=c4.cross(c1).z;
    float area = Math.abs(0.5f * (i1 + i2 + i3 + i4));

    if (area > maxArea) {
      maxArea = area;
      maxIdx = i;
    }
    i++;
  }
  return quads.get(maxIdx);
}