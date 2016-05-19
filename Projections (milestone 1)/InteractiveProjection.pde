/**
* @file Projections.pde - Assignment #2
* @brief Basic transformations and projections in 2D and 3D
*
* @authors Pere Adell  
*          Thierry Bossy
*          Rafael Pizzarro
* @date 08.03.2016
*/

void settings() { size(800, 800, P3D); }
void setup() {}
/**
* Given 
*/


void draw(){
  My3DPoint eye = new My3DPoint(0, 0, -500);
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox input3DBox = new My3DBox(origin, 80, 80, 80);
  background(255);
  
  
  /* Rotation around the x-axis */
  float[][] t1 = rotateXMatrix(rx);
  input3DBox = transformBox(input3DBox, t1);
  
  /* Rotation around the y-axis */
  float[][] t2 = rotateYMatrix(ry);
  input3DBox = transformBox(input3DBox, t2);

  /* Scale */
  float[][] t3 = scaleMatrix(scale,scale,scale);
  input3DBox = transformBox(input3DBox, t3);

  /* Translation to the center of the window */
  float[][] t4 = translationMatrix((width - 80) / 2, (height - 80) / 2, 0);
  input3DBox = transformBox(input3DBox, t4);
  projectBox(eye, input3DBox).render();
}

/**
* Rotation angles modified by keyPressed.
*/
float rx = 0;
float ry = 0;

/**
* Scaling factor.
*/
float scale = 1.0;

/**
* Translated a 3D-Point p into the eye's reference frame
* before projecting it.
*/
My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
 float px = (-eye.x + p.x) / (1 - (p.z / eye.z));
 float py = (-eye.y + p.y) / (1 - (p.z / eye.z));
 return new My2DPoint(px, py);
}
/**
* Projects all the points from a 3DBox to a 2DBox.
*/
My2DBox projectBox(My3DPoint eye, My3DBox box) {
  My2DPoint[] p = new My2DPoint[box.p.length];
  for (int i = 0; i < p.length; i++) {
    p[i] = projectPoint(eye, box.p[i]);
  }
  return new My2DBox(p);
}
/**
* Adds the homogenous dimension to a 3D-Point p.
*/
float[] homogeneous3DPoint(My3DPoint p) {
  float[] result = { p.x, p.y, p.z, 1 };
  return result;
}
/**
* Restores the homogeneous to a 3D-Point
*/
My3DPoint euclidian3DPoint(float[] a) {
  My3DPoint result = new My3DPoint(a[0] / a[3], a[1] / a[3], a[2] / a[3]);
  return result;
}
/**
* Rotation around the x-axis.
*/
float[][] rotateXMatrix(float angle) {
  return new float[][] { { 1, 0, 0, 0},
                         { 0, cos(angle), sin(angle), 0 },
                         { 0, -sin(angle), cos(angle), 0 },
                         { 0, 0, 0, 1 } };
}
/**
* Rotation around the y-axis.
*/
float[][] rotateYMatrix(float angle) {
  return new float[][] { { cos(angle), 0, sin(angle), 0},
                         { 0, 1, 0, 0 },
                         { -sin(angle), 0, cos(angle), 0 },
                         { 0, 0, 0, 1 } };
}
/**
* Rotation around the z-axis.
*/
float[][] rotateZMatrix(float angle) {
  return new float[][] { { cos(angle), -sin(angle), 0, 0},
                         { sin(angle), cos(angle), 0, 0 },
                         { 0, 0, 1, 0 },
                         { 0, 0, 0, 1 } };
}
/**
* Scaling of a 3D-point
*/
float[][] scaleMatrix(float x, float y, float z) {
  return new float[][] { { x, 0, 0, 0 },
                         { 0, y, 0, 0 },
                         { 0, 0, z, 0 },
                         { 0, 0, 0, 1 } };
}
/**
* Transformation of a 3D-point
*/
float[][] translationMatrix(float x, float y, float z) {
  return new float[][] { { 1, 0, 0, x },
                         { 0, 1, 0, y },
                         { 0, 0, 1, z },
                         { 0, 0, 0, 1 } };
}
/**
* Matrix multiplication
*/
float[] matrixProduct(float[][] a, float[] b) {
  float[] c = new float[b.length];
  for (int i = 0; i < a.length; i++) {
    for (int j = 0; j < b.length; j++) {
      c[i] += (a[i][j] * b[j]);
    }
  }
  return c;
}
/**
* Iteration over all points of a box to create a new 3DBox object
*/
My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] p = new My3DPoint[box.p.length];
  for (int i = 0; i < p.length; i++) {
    p[i] = euclidian3DPoint(matrixProduct(transformMatrix, homogeneous3DPoint(box.p[i])));
  }
  return new My3DBox(p);
}
/**
* Class for a 2D point
*/
class My2DPoint {
  float x;
  float y;
  
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

/**
* Class for a 3DPoint
*/
class My3DPoint {
  float x;
  float y;
  float z;
  
  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

/**
* Class for a 2D Box
*/
class My2DBox {
  My2DPoint[] s;
  
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  
  /**
  * Drawing the 2DBox 
  */
  public void render() {
    strokeWeight(4);    
    stroke(0, 255, 0);
    line(s[5].x, s[5].y, s[6].x, s[6].y);
    line(s[6].x, s[6].y, s[7].x, s[7].y);
    line(s[7].x, s[7].y, s[4].x, s[4].y);
    line(s[4].x, s[4].y, s[5].x, s[5].y); 
    stroke(0, 0, 255);
    line(s[1].x, s[1].y, s[5].x, s[5].y);
    line(s[2].x, s[2].y, s[6].x, s[6].y);  
    line(s[0].x, s[0].y, s[4].x, s[4].y);
    line(s[3].x, s[3].y, s[7].x, s[7].y);
    stroke(255, 0, 0);
    line(s[0].x, s[0].y, s[1].x, s[1].y);
    line(s[0].x, s[0].y, s[3].x, s[3].y);
    line(s[2].x, s[2].y, s[3].x, s[3].y);
    line(s[2].x, s[2].y, s[1].x, s[1].y);   
  }
}
/**
* Class for a 3D Box
*/
class My3DBox {
  My3DPoint[] p;
  
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ) {
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    
    this.p = new My3DPoint[] { new My3DPoint(x, y + dimY, z + dimZ),
                               new My3DPoint(x, y, z + dimZ),
                               new My3DPoint(x + dimX, y, z + dimZ),
                               new My3DPoint(x + dimX, y + dimY, z + dimZ),
                               new My3DPoint(x, y + dimY, z),
                               origin,
                               new My3DPoint(x + dimX, y, z),
                               new My3DPoint(x + dimX, y + dimY, z) };
  }
  
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}

// Drag (click and hold) your mouse across the 
// image to change the value of the rectangle

void mouseDragged() 
{
  if((pmouseX - mouseX) + (pmouseY - mouseY) >= 0)
    scale *= 1.1; 
  else {
    scale *= 0.9;
  }
}

/**
* By pressing the arrow key the user rotates the
* cuboid around the x- and y-axis.
*/
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      rx += 0.10;
    }
    else if (keyCode == DOWN) {
      rx -= 0.10;
    }
    else if (keyCode == LEFT) {
      ry += 0.10;
    }
    else if (keyCode == RIGHT) {
      ry -= 0.10;
    }
  }
}