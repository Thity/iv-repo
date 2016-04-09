
void settings() {
  size(700, 700, P3D);
}

void setup() {
  noStroke();
  createCylinder();
}

// The dimensions of the box.
private final static float boxX = 400;
private final static float boxY = 15;
private final static float boxZ = 400;
private final static float radiusBall = 20;


// The dimensions of the cylinders.
float cylinderBaseSize = 25;
float cylinderHeight = 40;
int cylinderResolution = 40;
PShape openCylinder = new PShape();
PShape closingCircleBottom = new PShape();
PShape closingCircleTop = new PShape();
public ArrayList<PVector> cylinders = new ArrayList<PVector>(); /* Stores the
                                                                 * position of
                                                                 * each cylinder.
                                                                 */
//The rotation of the box.
private float rx = 0;
private float rz = 0;
private float speed = 1;

// Booleans to control the mouse and keyboard inputs.
private boolean shift = false;
private boolean mouseClick = false;

// The ball on the box
private Mover ball = new Mover(-1 * boxX / 2, boxX / 2, -1 * boxZ / 2, boxZ / 2, radiusBall);
private final static float ballOffset = radiusBall + (boxY/ 2) + 1;
private final static float smooth = 0.01;

void draw() {
  
  directionalLight(50, 100, 125, -1, 1, -1);
  ambientLight(102, 102, 102);
  background(255);
  fill(200);
  
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
      if ((mouseX-width/2) > -boxX/2 && (mouseX-width/2) < boxX/2 &&
          (mouseY-height/2) > -boxZ/2 && (mouseY-height/2) < boxZ/2)
        cylinders.add(new PVector(mouseX-width/2, -(mouseY-height/2)));
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

//deplacement of the box with mouse
void mouseDragged(){
  if(!shift){
  rx += -(mouseY - pmouseY) * smooth * speed;
  if (rx < -PI/3){
    rx = -PI/3;
  } else if(rx > PI/3){
    rx = PI/3;
  }
  
  rz += (mouseX - pmouseX) * smooth * speed;
  if (rz < -PI/3){
     rz = -PI/3;
  } else if (rz > PI/3){
     rz = PI/3;
  }
  }
}

//change the speed of the manipulation of the box with the wheel of the mouse
void mouseWheel(MouseEvent event){
  if(!shift){
   float e = event.getCount();
   if(e > 0 && speed < 3){
     speed += 0.1;
   }
   else if(e < 0 && speed > 0.2){
     speed -= 0.1;
   }
  }
}
// To allow to click when shift is pressed.
void mousePressed(){
  if(shift){
    mouseClick = true;
  }
}
// To determine if a key (shift key) has been pressed or released.
void keyPressed(){
   if ((key == CODED) && (keyCode == SHIFT))
     shift = true;
}
void keyReleased(){
   if ((key == CODED) && (keyCode == SHIFT))
     shift = false;
}

// Draws all the cylinder shapes using the positions stored in the cylinder array.
void drawCylinders() {
  for(PVector c : cylinders){
    pushMatrix();
    translate(c.x, -boxY/2, -c.y);
    rotateX(PI/2);    
    shape(openCylinder);
    shape(closingCircleBottom);
    shape(closingCircleTop);
    popMatrix();
  }
}

/* Creation of the shape of a closed cylinder. */
void createCylinder(){
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] y = new float[cylinderResolution + 1];
  //get the x and y position on a circle for all the sides.
  for(int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    y[i] = cos(angle) * cylinderBaseSize;
  }
  // Creates the cylinder border.
  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  //draw the border of the cylinder
  for(int i = 0; i < x.length; i++) {
    openCylinder.vertex(x[i], y[i] , 0);
    openCylinder.vertex(x[i], y[i], cylinderHeight);
  }
  openCylinder.endShape();
  
  //Creates the cylinder bottom face. 
  closingCircleBottom = createShape();
  closingCircleBottom.beginShape(TRIANGLE_FAN);
  closingCircleBottom.vertex(0, 0, 0);
  for(int i = 0; i < x.length; i++) {
    closingCircleBottom.vertex(x[i], y[i] , 0);
  }
  closingCircleBottom.endShape();
  
  //Creates the cylinder top face.
  closingCircleTop = createShape();
  closingCircleTop.beginShape(TRIANGLE_FAN);
  closingCircleTop.vertex(0, 0, cylinderHeight);
  for(int i = 0; i < x.length; i++) {
    closingCircleTop.vertex(x[i], y[i], cylinderHeight);
  }
  closingCircleTop.endShape();
}
