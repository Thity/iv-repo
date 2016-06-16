class ImageProcessing extends PApplet {
  Capture cam;
  //...
  void settings() {
    size(WINDOW_WIDTH, WINDOW_HEIGHT, P3D);
  }
  void setup() {
    noStroke();
    setupCylinderShapes();
    dashboard = new Dashboard();
    ball = new Mover(-boxX / 2, boxX / 2, -boxZ / 2, boxZ / 2, radiusBall, dashboard);
  }
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
  //...
}