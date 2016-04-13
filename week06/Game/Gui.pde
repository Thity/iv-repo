PGraphics guiBackground;
PGraphics guiTopView;

void guiBackground() {
  guiBackground.beginDraw();
  guiBackground.background(200, 225, 150);
  guiBackground.endDraw();
}
void guiTopView() {
  guiTopView.beginDraw();
  guiTopView.background(255);
  guiTopView.endDraw();
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