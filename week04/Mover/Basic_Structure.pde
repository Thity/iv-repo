class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(1, 1);
    acceleration = new PVector(0, 0.1);
  }
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
  }
  void display() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(location.x, location.y, 48, 48);
  }
  void checkEdges() {
    if (location.x > width - 24) {
      location.x = width - 24;
      velocity.x *= -1;
    } else if (location.x < 24) {
      location.x = 24;
      velocity.x *= -1;
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
