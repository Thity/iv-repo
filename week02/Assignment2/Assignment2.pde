/**
* @file Projections.pde - Assignment #2
* @brief Basic transformations and projections in 2D and 3D
*
* @authors Pere Adell  
*          Thierry Bossy
*          Rafael Pizzarro
* @date 01.03.2016
*/
void settings() {
  size(1000, 1000, P2D);
}
void setup () {
}
void draw() {
  background(255, 255, 255);
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0);

  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
  
  //rotated around x
  float[][] transform1 = rotateXMatrix(PI/8);
  input3DBox = transformBox(input3DBox, transform1);
  projectBox(eye, input3DBox).render();
  //rotated and translated
  float[][] transform2 = translationMatrix(200, 200, 0);
  input3DBox = transformBox(input3DBox, transform2);
  projectBox(eye, input3DBox).render();
  //rotated, translated, and scaled
  float[][] transform3 = scaleMatrix(2, 2, 2);
  input3DBox = transformBox(input3DBox, transform3);
  projectBox(eye, input3DBox).render();
}

class My2DPoint {
  float x;
  float y;
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

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

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) { 
  float [][] T = {{ 1, 0, 0, -eye.x}, 
    { 0, 1, 0, -eye.y}, 
    { 0, 0, 1, -eye.z}, 
    { 0, 0, 0, 1 } 
  };

  float [][] P ={{ 1, 0, 0, 0}, 
    { 0, 1, 0, 0}, 
    { 0, 0, 1, 0}, 
    { 0, 0, 1/(-eye.z), 0}
  };

  float [][] transformation = multiply(P, T);
  float [][] point = {{p.x}, {p.y}, {p.z}, {1}};
  float [][] perspective = multiply(transformation, point);
  My2DPoint projected = new My2DPoint((perspective[0][0])/(perspective[3][0]), (perspective[1][0])/(perspective[3][0]));

  return projected;
}

float[][] multiply(float[][] A, float[][] B) {
  int lignes = A.length;
  int colonnes = B[0].length;
  int lignesB = B.length;

  if (A[0].length == lignesB) {

    float[][] matrix = new float [lignes][colonnes];

    for (int i = 0; i < lignes; i++) {
      for (int j = 0; j < colonnes; j++) {

        for (int k = 0; k < lignesB; k++) {
          matrix[i][j] += A[i][k] * B[k][j];
        }
      }
    }
    return matrix;
  } else return null;
}

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  void render() {
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

class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ) {
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{new My3DPoint(x, y+dimY, z+dimZ), 
      new My3DPoint(x, y, z+dimZ), 
      new My3DPoint(x+dimX, y, z+dimZ), 
      new My3DPoint(x+dimX, y+dimY, z+dimZ), 
      new My3DPoint(x, y+dimY, z), 
      origin, 
      new My3DPoint(x+dimX, y, z), 
      new My3DPoint(x+dimX, y+dimY, z)
    };
  }
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}

My2DBox projectBox (My3DPoint eye, My3DBox box) { 
  My2DPoint[] s = new My2DPoint[8];

  for (int i=0; i < 8; i++) {
    s[i] = projectPoint(eye, box.p[i]);
  }
  My2DBox box2D = new My2DBox(s);
  return box2D;
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