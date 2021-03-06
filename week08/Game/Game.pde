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
private final static int boxX = 400;
private final static int boxY = 15;
private final static int boxZ = 400;
private final static int boxCenterX = WINDOW_WIDTH/2;
private final static int boxCenterY = 2*WINDOW_HEIGHT/5;
private Dashboard dashboard;


//Mouse

// Classes


void setup() {
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
  background(255);
  lights();
  fill(200);

  // The Object Placement Mode when the shift is pressed and otherwise the Game Mode.

  if (!shift) {
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
  /*
  dashboard.drawBackground();
  dashboard.drawTopView(cylinders, cylinderBaseRadius, radiusBall, ball.location, boxX);
  dashboard.drawTextView();
  dashboard.updateScroll();
  */
}

//inputs 
//void mouseDragged(){ input.mouseDragged();}
//void mouseWheel(MouseEvent event){ input.mouseWheel(event);}
//void mousePressed(){ input.mousePressed();}
//void keyPressed(){ input.keyPressed();}   
//void keyReleased(){ input.keyReleased();}