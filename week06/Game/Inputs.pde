
class Inputs {
  // Booleans to control the mouse and keyboard inputs.
  private boolean shift = false;
  private boolean mouseClick = false;
  
  
  //deplacement of the box with mouse
  public void mouseDragged(){
    if(!shift){
    rx += -(mouseY - pmouseY) * smooth * speed;
    if (rx < -PI/3){
      rx = -PI/3;
    } else if(rx > PI/3){
      rx = PI/3;
    }
    
    rz += (mouseX - pmouseX) * smooth * speed;
    if (rz < -PI/3){
       rz = -PI/3;
    } else if (rz > PI/3){
       rz = PI/3;
    }
    }
  }
  
  //change the speed of the manipulation of the box with the wheel of the mouse
  public void mouseWheel(MouseEvent event){
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
  // To allow to click when shift is pressed.
  public void mousePressed(){
    if(shift){
      mouseClick = true;
    }
  }
  // To determine if a key (shift key) has been pressed or released.
  public void keyPressed(){
     if ((key == CODED) && (keyCode == SHIFT))
       shift = true;
  }
  public void keyReleased(){
     if ((key == CODED) && (keyCode == SHIFT))
       shift = false;
  }
  public boolean getMouseClick() {
    return mouseClick;
  }
  public void setMouseClick(boolean Boole){
    mouseClick = Boole;
  }
  public boolean getShift() {
    return mouseClick;
  }
  public void setShift(boolean Boole){
    mouseClick = Boole;
  }
}