class Mover {
  PVector location;
  PVector velocity;
  PVector gravityForce;
  float gravityConstant = 1;
  
  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(1, 1);
    gravityForce = new PVector(sin(rz) * gravityConstant, sin(rx) * gravityConstant);
  }
  void update() {
    velocity.add(gravityForce);
    location.add(velocity);
  }
  void display() {
    fill(127);
  }
  void checkEdges() {
    if (location.x > width - 24) {
      velocity.x *= -1;
      location.x = width - 24;
    } else if (location.x < 24) {
      velocity.x *= -1;
      location.x = 24;
    }
    if (location.y > height - 24) {
      location.y = height - 24;
      velocity.y *= -1;
    } else if (location.y < 24){
      location.y = 24;
      velocity.y *= -1;
    }
  }
}