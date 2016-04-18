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

// Classes

private Gui gui = new Gui();
//private Inputs input = new Inputs();

void setup() {
  noStroke();
  setupBall();
  gui.setupGui();
  setupCylinderShapes();
}


//The rotation of the box.
private float rx = 0;
private float rz = 0;
private float speed = 1;

void draw() {
  //Background and Light
  directionalLight(50, 100, 125, -1, 1, -1);
  ambientLight(102, 102, 102);
  background(255);
  fill(200);
  
  gui.drawGui();

  
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
    //if (input.getMouseClick()) {
      if (mouseClick) {
          if(checkCylindersBox() && checkCylindersBall())
            addCylinder();
            mouseClick = false;
        }
      //input.setMouseClick(false);
      mouseClick = false;
    }
  }
  popMatrix();
  
  fill(50);
  text("X rotation =" + Math.round(Math.toDegrees(rx) * 100.0) / 100.0, 20, 20);
  text("Z rotation =" + Math.round(Math.toDegrees(rz) * 100.0) / 100.0, 20, 40);
  text("Speed = " + Math.round(speed * 100.0) / 100.0, 20, 60);
  //text("SHIFT = " + input.getShift(), 20, 80);
  text("SHIFT = " + shift, 20, 80);
}

//inputs 
//void mouseDragged(){ input.mouseDragged();}
//void mouseWheel(MouseEvent event){ input.mouseWheel(event);}
//void mousePressed(){ input.mousePressed();}
//void keyPressed(){ input.keyPressed();}   
//void keyReleased(){ input.keyReleased();}