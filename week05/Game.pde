
void settings() {
  size(700, 700, P3D);
}

void setup() {
  noStroke();
}

//dimensions of the box
private final static float boxX = 400;
private final static float boxY = 15;
private final static float boxZ = 400;
private final static float radiusBall = 20;

//The rotation of the box
private float rx = 0;
private float rz = 0;
private float speed = 1;
private boolean shift = false;
private ArrayList<PVector> cylinders;

// The ball on the box
private Mover ball = new Mover(-1 * boxX / 2, boxX / 2, -1 * boxZ / 2, boxZ / 2, radiusBall);
private final static float ballOffset = radiusBall + (boxY/ 2) + 1;

void draw() {
  shift = (keyPressed && (keyCode == SHIFT));
  directionalLight(50, 100, 125, 0, 1, 0);
  ambientLight(102, 102, 102);
  background(255);
  
  if(shift){
  pushMatrix();
  
  translate(width/2, height/2, 0);
  rect(-boxX/2, -boxZ/2, boxX, boxZ);
  
  popMatrix();
  } else {
    
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
  }
  
  text("X rotation =" + Math.round(Math.toDegrees(rx) * 100.0) / 100.0, 20, 20);
  text("Z rotation =" + Math.round(Math.toDegrees(rz) * 100.0) / 100.0, 20, 40);
  text("Speed = " + Math.round(speed * 100.0) / 100.0, 20, 60);
  text("SHIFT = " + shift, 20, 80);  
}  

//deplacement of the box with mouse
void mouseDragged(){
  if(!shift){
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

void mousePressed(){
  if(shift){
    cylinders.add(new PVector(mouseX, mouseY));
  }
}
