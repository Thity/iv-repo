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



// Box
private final static int boxSide = 400;
private final static int boxX = boxSide;
private final static int boxY = 15;
private final static int boxZ = boxSide;
private final static int boxCenterX = WINDOW_WIDTH/2;
private final static int boxCenterY = 2*WINDOW_HEIGHT/5;
private Dashboard dashboard;


//Mouse

// Classes

ImageProcessing imgproc;

void setup() {

  //...
  imgproc = new ImageProcessing();
  String []args = {"Image processing window"};
  PApplet.runSketch(args, imgproc);
  //...
  PVector rot = imgproc.getRotation();
  // where getRotation could be a getter
  //for the rotation angles you computed previously
}


//The rotation of the box.
private float rx = 0;
private float rz = 0;
private float speed = 1;