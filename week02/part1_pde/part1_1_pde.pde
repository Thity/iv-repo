 void settings() {
      size (400, 400, P2D);
    }
    void setup() {
    }
    void draw() {
      line (200, 200, 400, 400);
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
      float [][] T ={{ 1, 0, 0, -eye.x},
                     { 0, 1, 0, -eye.y},
                     { 0, 0, 1, -eye.z},
                     { 0, 0, 0, 1 } 
                   };
                   
      float [][] P ={{ 1, 0, 0, 0},
                     { 0, 1, 0, 0},
                     { 0, 0, 1, 0},
                     { 0, 0, 1/(-eye.z), 0}
                   };
                   
    public static float[][] multiply(float[][] A, float[][] B) {
    int lignes = A.length;
    int colonnes = B[0].length;
    int lignesB = B.length;
    
    if (A[0].length == lignesB) {
      
        float[][] matrix = new float [lignes][colonnes];
      
        for (int i = 0 ; i < lignes ; i++) {
          for (int j = 0 ; j < colonnes ; j++) {
            
                  for (int k = 0 ; k < lignesB ; k++) {
                    matrix[i][j] += A[i][k] * B[k][j];
                  }
          }
        }
        return matrix;} else return null;
  }               
  }
