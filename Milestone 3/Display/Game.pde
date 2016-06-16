/**
 * @file Game.pde
 * @brief Game with a pad and a ball
 *
 * @authors Pere Adell  
 *          Thierry Bossy
 *          Rafael Pizzarro
 * @date 29.03.2016
 */

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

// Image
private PImage img;

//Mouse

// Classes
Movie cam;
ImageProcessing imgproc;
void setup() {
  cam = new Movie(this, "testvideo.mp4");
  cam.loop();
  noStroke();
  setupCylinderShapes();
  dashboard = new Dashboard();
  ball = new Mover(-boxX / 2, boxX / 2, -boxZ / 2, boxZ / 2, radiusBall, dashboard);

  // For image processing
  //...
  imgproc = new ImageProcessing();
  String []args = {"Image processing window"};
  PApplet.runSketch(args, imgproc);
  //...
  //PVector rot = imgproc.getRotation();
  // where getRotation could be a getter
  //for the rotation angles you computed previously
}


//The rotation of the box.
private float rx = 0;
private float rz = 0;
private float speed = 1;

void draw() {
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

  doImageProcessing();
}


// For image processing
private Convolution conv = new Convolution();
private FilterColors filter = new FilterColors();
private QuadGraph qg = new QuadGraph();
// for filtering lego board
private float minHue = 96;
private float maxHue = 144;
private float minSat = 100;
private float maxSat = 255;
private float minBri = 32;
private float maxBri = 149;



void doImageProcessing() {
  img = cam.get();
  img = filter.HSBFilter(img, minHue, maxHue, minSat, maxSat, minBri, maxBri);
  img = conv.gaussianBlur(img);
  img = conv.gaussianBlur(img);
  img = filter.transformToBW(img, 150, 255);
  img = conv.gaussianBlur(img);
  img = conv.gaussianBlur(img);
  PImage sobelImg = conv.sobel(img);
  Hough hough = new Hough();
  hough.hough(sobelImg);

  PImage houghImg = hough.houghImg();

  hough.drawBestLines(img);
  hough.drawIntersections();
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
}