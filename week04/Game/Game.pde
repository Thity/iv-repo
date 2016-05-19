float depth = 2000;
float rx = 0;
float rz = 0;
float speed = 1;

float xPos = 0;
float yPos = -31.5;
float zPos = 0;

Mover mover;


void settings() {
  size(500, 500, P3D);
}

void setup() {
  mover = new Mover();
  noStroke();
}

void draw() {
  directionalLight(50, 100, 125, 0, 1, 0);
  ambientLight(102, 102, 102);
  background(200);
  translate(width/2, height/2, 0);
  //ellipse(0, -31.5, 48, 48);
  
  mover.update();
  mover.checkEdges();
  mover.display();
  
  rotateX(rx);
  rotateZ(rz);
  pushMatrix();
  box(300, 15, 300);
  
  translate(xPos, yPos, -zPos);
  sphere(24);
  
  xPos = xPos + (mover.velocity.x);
  //yPos = yPos + (mover.velocity.y);
  zPos = yPos + (mover.velocity.y);
  
  popMatrix();
  
  
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