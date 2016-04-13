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