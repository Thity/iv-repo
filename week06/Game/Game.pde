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
private final static float boxX = 400;
private final static float boxY = 15;
private final static float boxZ = 400;

// Classes

private Gui gui = new Gui();
private Inputs input = new Inputs();

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
  if (!input.getShift()) {
    pushMatrix();
    translate(width/2, height/2, 0);
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
    translate(width/2, height/2, 0);
    rotateX(-PI/2);
    box(boxX, boxY, boxZ);    
    drawCylinders();
    translate(ball.location.x, -ballOffset, -ball.location.y);
    ball.display();
    if (input.getMouseClick()) {
      if ((mouseX-width/2) > -boxX/2 + cylinderBaseSize && (mouseX-width/2) < boxX/2 - cylinderBaseSize &&
          (mouseY-height/2) > -boxZ/2 + cylinderBaseSize && (mouseY-height/2) < boxZ/2 - cylinderBaseSize){
        cylinders.add(new PVector(mouseX-width/2, -(mouseY-height/2)));
        }
      input.setMouseClick(false);
    }
  }
  popMatrix();
  
  fill(50);
  text("X rotation =" + Math.round(Math.toDegrees(rx) * 100.0) / 100.0, 20, 20);
  text("Z rotation =" + Math.round(Math.toDegrees(rz) * 100.0) / 100.0, 20, 40);
  text("Speed = " + Math.round(speed * 100.0) / 100.0, 20, 60);
  text("SHIFT" + input.getShift(), 20, 80);  
}
//inputs 
void mouseDragged(){ input.mouseDragged();}
void mouseWheel(MouseEvent event){ input.mouseWheel(event);}
void mousePressed(){ input.mousePressed();}
void keyPressed(){ input.keyPressed();}   
void keyReleased(){ input.keyReleased();}