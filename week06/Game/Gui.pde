PGraphics backgroundData;
PGraphics topView;

void drawBackgroundData() {
  backgroundData.beginDraw();
  backgroundData.background(0);
  backgroundData.endDraw();
}
void drawTopView() {
  topView.beginDraw();
  topView.background(255);
  topView.endDraw();
}
// Draws all the cylinder shapes using the positions stored in the cylinder array.
void drawCylindersTopView() {
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

// Create ellipses
void createCylinderTopView() {
  
}