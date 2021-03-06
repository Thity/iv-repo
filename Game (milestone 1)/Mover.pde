/**
* @file Mover.pde
* @brief Mover for the ball of the game
*
* @authors Pere Adell  
*          Thierry Bossy
*          Rafael Pizzarro
* @date 30.03.2016
*/

class Mover {
  private PVector location;
  private PVector velocity;
  private PVector gravity;
  
  private float xMin;
  private float xMax;
  private float yMin;
  private float yMax;
  private float radiusBall;
  
  Mover(float xMin, float xMax, float yMin, float yMax, float radiusBall) {
    this.location = new PVector(0, 0);
    this.velocity = new PVector(0, 0);
    this.gravity = new PVector(0, 0);
    
    this.xMin = xMin;
    this.xMax = xMax;
    this.yMin = yMin;
    this.yMax = yMax;
    this.radiusBall = radiusBall;
  }
  
  // set the gravity to the down, the velocity and the location
  void update(float rx, float rz) {
    gravity.x = sin(rz)*0.1;
    gravity.y = sin(rx)*0.1;
    
    velocity.add(gravity);
    velocity.add(friction());
    location.add(velocity);
    checkCylinderCollision();
  }
  
  PVector friction() {
    float normalForce = 1;
    float mu = 0.01;
    float frictionMagnitude = normalForce * mu;
    PVector friction = velocity.copy();
    
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    return friction;
  }
  
  
  void display() {
    sphere(radiusBall);
  }
  
  // bounce if the ball hit the edges of the box
  void checkEdges() {
    if (location.x >= xMax) {
      velocity.x *= -0.8;
      location.x = xMax;
    } else if (location.x <= xMin ) {
      velocity.x *= -0.8;
      location.x = xMin;
    }
    if (location.y >= yMax) {
      velocity.y *= -0.8;
      location.y = yMax;
    } else if (location.y <= yMin){
      velocity.y *= -0.8;
      location.y = yMin;
    }
  }
  //////////////////////////////////
  void checkCylinderCollision() {
    for(PVector c : cylinders) {
      float d = location.dist(c);
      if (d <= radiusBall + cylinderBaseSize) {
        PVector n = c.copy().sub(location).normalize();
        velocity.sub(n.copy().mult(1.8 * (velocity.dot(n))));
        location = c.copy().add(n.mult(-d*1.01));
      }
    }
  }
}
