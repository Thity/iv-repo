float depth = 2000;
float rx = 0;
float rz = 0;
float speed = 1;

void settings() {
  size(500, 500, P3D);
}

void setup() {
  noStroke();
}

void draw() {
  directionalLight(50, 100, 125, 0, 1, 0);
  ambientLight(102, 102, 102);
  background(200);
  translate(width/2, height/2, 0);
  //ellipse(0, -31.5, 48, 48);
  
  rotateX(rx);
  rotateZ(rz);
  pushMatrix();
  box(300, 15, 300);
  popMatrix();
  
  translate(0, -31.5, 0);
  sphere(24);
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
