/**
  @File Mover.pde
*/
private final static float radiusBall = 12;
private final static float ballOffset = radiusBall + (boxY/ 2) + 1;
private final static float smooth = 0.01;
private Mover ball;

class Mover {
  private PVector location;
  private PVector velocity;
  private PVector gravity;
  private float normalForce; 
  private final static float mu = 0.01;

  
  private float xMin;
  private float xMax;
  private float yMin;
  private float yMax;
  private float ballRadius;
  private PVector friction;
  
  private Dashboard dashboard;
  
  Mover(float xMin, float xMax, float yMin, float yMax, float ballRadius, Dashboard dashboard) {
    this.location = new PVector(0, 0);
    this.velocity = new PVector(0, 0);
    this.gravity = new PVector(0, 0);
    normalForce = 0;
    
    this.xMin = xMin;
    this.xMax = xMax;
    this.yMin = yMin;
    this.yMax = yMax;
    this.ballRadius = ballRadius;
    
    this.dashboard = dashboard;
  }
      
  /**
    Updates the balls velocity and location based on the
    rotation of the board, the ball's friction and the 
    collisions with the board edges and cylinders
  */
  void update(float rX, float rZ) {
    gravity.x = sin(rZ) * 0.1;
    gravity.y = sin(rX) * 0.1;
    normalForce = abs(cos(rZ));

    
    velocity.add(gravity);
    velocity.add(friction());
    location.add(velocity);
    checkCylinderCollision();
  }
  
  /**
    Returns the friction vector of the ball
  */
  PVector friction() {
    //float normalForce = 1;
    float frictionMagnitude = normalForce * mu;
    friction = velocity.copy();
    
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    return friction;
  }
      
  /**
    Draws a sphere with radius ballRadius
  */
  void display() {
    sphere(ballRadius);
  }
  
  /**
    Rebounce calculation when the ball hits the
    edge of the playing board
  */
  void checkEdges() {
    if (location.x >= xMax) {
       dashboard.addScore(-velocity.mag());
       velocity.x = velocity.x * -0.70;
       location.x = xMax;
    } else if (location.x <= xMin) {
        dashboard.addScore(-velocity.mag());
        velocity.x = velocity.x * -0.70;
        location.x = xMin;
    }
     
    if (location.y >= yMax) {
        dashboard.addScore(-velocity.mag());
         velocity.y = velocity.y * -0.70;
         location.y = yMax;
    } else if (location.y <= yMin) {
         dashboard.addScore(-velocity.mag());
         velocity.y = velocity.y * -0.70;
         location.y = yMin;
    }
  } 
  
  /**
    Rebounce calculation when the ball hits a cylinder
  */
  void checkCylinderCollision() {
    for(PVector c : cylinders) {
      float d = location.dist(c);
      if (d <= ballRadius + cylinderBaseRadius) {
        PVector n = c.copy().sub(location).normalize();
        velocity.sub(n.copy().mult(2 * (velocity.dot(n))));
        location = c.copy().add(n.mult(-d*1.01));
        dashboard.addScore(velocity.mag());
      }
    }
  }
  public PVector getLocation() { return location; }
  public float getVelocity() { return velocity.mag(); }
}