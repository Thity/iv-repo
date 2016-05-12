float cylinderBaseSize = 50;
float cylinderHeight = 50;
int cylinderResolution = 40;
PShape openCylinder = new PShape();
PShape closingCircleBottom = new PShape();
PShape closingCircleTop = new PShape();
void settings() {
size(400, 400, P3D);
}
void setup() {
float angle;
float[] x = new float[cylinderResolution + 1];
float[] y = new float[cylinderResolution + 1];
//get the x and y position on a circle for all the sides
for(int i = 0; i < x.length; i++) {
  angle = (TWO_PI / cylinderResolution) * i;
  x[i] = sin(angle) * cylinderBaseSize;
  y[i] = cos(angle) * cylinderBaseSize;
}
openCylinder = createShape();
openCylinder.beginShape(QUAD_STRIP);
//draw the border of the cylinder
for(int i = 0; i < x.length; i++) {
  openCylinder.vertex(x[i], y[i] , 0);
  openCylinder.vertex(x[i], y[i], cylinderHeight);
}
openCylinder.endShape();

closingCircleBottom = createShape();
closingCircleBottom.beginShape(TRIANGLE_FAN);
closingCircleBottom.vertex(0, 0, 0);
for(int i = 0; i < x.length; i++) {
  closingCircleBottom.vertex(x[i], y[i] , 0);
}
closingCircleBottom.endShape();
closingCircleTop = createShape();
closingCircleTop.beginShape(TRIANGLE_FAN);
closingCircleTop.vertex(0, 0, cylinderHeight);
for(int i = 0; i < x.length; i++) {
  closingCircleTop.vertex(x[i], y[i], cylinderHeight);
}
closingCircleTop.endShape();
}
void draw() {
background(255);
translate(mouseX, mouseY, 0);
shape(openCylinder);
shape(closingCircleBottom);
shape(closingCircleTop);
}
