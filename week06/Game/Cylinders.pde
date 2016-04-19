/**
* @file Cylinders.pde
* @brief All function that handle Cylinders
*
* @authors Pere Adell  
*          Thierry Bossy
*          Rafael Pizzarro
* @date 10.04.2016
*/

// The dimensions of the cylinders.
private final float cylinderBaseSize = 25;
private final float cylinderHeight = 40;
private final int cylinderResolution = 40;
private final float cylinderBaseRadius = 20;


PShape openCylinder = new PShape();
PShape closingCircleBottom = new PShape();
PShape closingCircleTop = new PShape();
public ArrayList<PVector> cylinders = new ArrayList<PVector>(); 
                                                                 
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

boolean checkCylindersBox() {
  return ((mouseX-boxCenterX) > -boxX/2 + cylinderBaseSize && 
   (mouseX-boxCenterX) < boxX/2 - cylinderBaseSize &&
   (mouseY-boxCenterY) > -boxZ/2 + cylinderBaseSize && 
   (mouseY-boxCenterY) < boxZ/2 - cylinderBaseSize);
}

boolean checkCylindersBall(){
 return ((mouseX-ball.getLocation().x) > -ball.getLocation().x + radiusBall && 
   (mouseX-ball.getLocation().x) < boxX/2 - radiusBall &&
   (mouseY-ball.getLocation().y) > -ball.getLocation().x + radiusBall && 
   (mouseY-ball.getLocation().y) < ball.getLocation().x - radiusBall);
}
void addCylinder() {
  cylinders.add(new PVector(mouseX-boxCenterX, -(mouseY-boxCenterY)));
}

/* Creation of the shape of a closed cylinder. */
void setupCylinderShapes(){
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