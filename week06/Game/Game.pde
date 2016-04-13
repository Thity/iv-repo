/**
* @file Game.pde
* @brief Game with a pad and a ball
*
* @authors Pere Adell  
*          Thierry Bossy
*          Rafael Pizzarro
* @date 29.03.2016
*/

void settings() {
  size(700, 700, P3D);
}

void setup() {
  noStroke();
  createCylinder();
  backgroundData = createGraphics(680,200,P2D);
  topView = createGraphics(180,180,P2D);
}

// The dimensions of the box.
private final static float boxX = 400;
private final static float boxY = 15;
private final static float boxZ = 400;
private final static float radiusBall = 12;

//The rotation of the box.
private float rx = 0;
private float rz = 0;
private float speed = 1;

void draw() {
  
  directionalLight(50, 100, 125, -1, 1, -1);
  ambientLight(102, 102, 102);
  background(255);
  fill(200);
  
  // Data visualisation background
  drawBackgroundData();
  image(backgroundData, 10, 490);
  // TopView
  drawTopView();
  image(topView, 20, 500);
  
  // The Object Placement Mode when the shift is pressed and otherwise the Game Mode.
  if (!shift) {
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
    if (mouseClick) {
      if ((mouseX-width/2) > -boxX/2 + cylinderBaseSize && (mouseX-width/2) < boxX/2 - cylinderBaseSize &&
          (mouseY-height/2) > -boxZ/2 + cylinderBaseSize && (mouseY-height/2) < boxZ/2 - cylinderBaseSize){
        cylinders.add(new PVector(mouseX-width/2, -(mouseY-height/2)));
        }
      mouseClick = false;
    }
  }
  popMatrix();
  
  fill(50);
  text("X rotation =" + Math.round(Math.toDegrees(rx) * 100.0) / 100.0, 20, 20);
  text("Z rotation =" + Math.round(Math.toDegrees(rz) * 100.0) / 100.0, 20, 40);
  text("Speed = " + Math.round(speed * 100.0) / 100.0, 20, 60);
  text("SHIFT = " + shift, 20, 80);  
}  