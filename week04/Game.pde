
void settings() {
  size(500, 500, P3D);
}

void setup() {
  noStroke();
}

private final static float boxX = 300;
private final static float boxY = 15;
private final static float boxZ = 300;
private final static float radiusBall = 20;

private float rx = 0;
private float rz = 0;
private float speed = 1;

private final static float smoothness = 0.01;
private Mover ball = new Mover(-1 * boxX / 2, boxX / 2, -1 * boxZ / 2, boxZ / 2, radiusBall);
private final static float ballOffset = radiusBall + (boxY/ 2) + 1;

void draw() {
  background(255, 255, 255);
  lights();
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(rx);
  rotateZ(rz);
  box(boxX, boxY, boxZ);
  
  translate(ball.location.x, -ballOffset, -ball.location.y);
  ball.update(rx, rz);
  ball.display();
  ball.checkEdges();
  
  popMatrix();
  text("X rotation =" + Math.round(Math.toDegrees(rx) * 100.0) / 100.0, 20, 20);
  text("Z rotation =" + Math.round(Math.toDegrees(rz) * 100.0) / 100.0, 20, 20);
  text("Speed = " + Math.round(speed * 100.0) / 100.0, 20, 60);
  
}  

 
void mouseDragged(){
  rx += -(mouseY - pmouseY) * 0.01 * speed;
  if (rx < -PI/3){
    rx = -PI/3;
  } else if(rx > PI/3){
    rx = PI/3;
  }
  
  rz += (mouseX - pmouseX) * 0.01 * speed;
  if (rz < -PI/3){
     rz = -PI/3;
  } else if (rz > PI/3){
     rz = PI/3;
  }
}
 
void mouseWheel(MouseEvent event){
   float e = event.getCount();
   if(e > 0 && speed < 3){
     speed += 0.1;
   }
   else if(e < 0 && speed > 0.2){
     speed -= 0.1;
   }
}