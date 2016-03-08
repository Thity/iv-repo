  
 // float rx = map(-mouseY*speed, 0, width, PI/3, PI);
  //float rz = map(mouseX*speed, 0, height, -PI/3, PI/3);
//  mouseDragged();
  rotateX(rx);
  rotateZ(rz);
  pushMatrix();
    box(300, 15, 300);
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