public class Matrix {
  float[][] matrix;
  
  public Matrix(float[][] values) {
    matrix = values; 
  }
  
  public Matrix() {
    float[][] values = {{1,0,0,0},{0,1,0,0},{0,0,1,0},{0,0,0,0}}; 
    matrix = values;
  }
  
  public Matrix createScale(float x, float y, float z) {
    float[][] values = {{x,0,0,0},{0,y,0,0},{0,0,z,0},{0,0,0,1}};
    return new Matrix(values);
  }
  
  public Matrix createTranslate(float x, float y, float z) {
    float[][] values = {{1,0,0,x},{0,1,0,y},{0,0,1,z},{0,0,0,1}};
    return new Matrix(values);
  }
  
  public Matrix createRotateX(float theta) {
    float[][] values = {{1,0,0,0},{0,cos(theta),-sin(theta),0},{0,sin(theta),cos(theta),0},{0,0,0,1}};
    return new Matrix(values);
  }
  
  public Matrix createRotateY(float theta) {
    float[][] values = {{cos(theta),0,sin(theta),0},{0,1,0,0},{-sin(theta),0,cos(theta),0},{0,0,0,1}};
    return new Matrix(values);
  }
  
  public Matrix createRotateZ(float theta) {
    float[][] values = {{cos(theta),-sin(theta),0,0},{sin(theta),cos(theta),0,0},{0,0,1,0},{0,0,0,1}};
    return new Matrix(values);
  }
  
  public void multiply(float[][] b) {
    float[][] a = matrix;
    //Separating Rows of First Matrix
    float[] row1A = a[0];
    float[] row2A = a[1];
    float[] row3A = a[2];
    float[] row4A = a[3];
    
    //Separating Rows of Second Matrix
    float[] row1B = b[0];
    float[] row2B = b[1];
    float[] row3B = b[2];
    float[] row4B = b[3];
    
    //Finding first Row of new Matrix
    float spot1 = (row1A[0]*row1B[0]) + (row1A[1]*row2B[0]) + (row1A[2]*row3B[0]) + (row1A[3]*row4B[0]);
    float spot2 = (row1A[0]*row1B[1]) + (row1A[1]*row2B[1]) + (row1A[2]*row3B[1]) + (row1A[3]*row4B[1]);
    float spot3 = (row1A[0]*row1B[2]) + (row1A[1]*row2B[2]) + (row1A[2]*row3B[2]) + (row1A[3]*row4B[2]);
    float spot4 = (row1A[0]*row1B[3]) + (row1A[1]*row2B[3]) + (row1A[2]*row3B[3]) + (row1A[3]*row4B[3]);
    float[] row1C = {spot1, spot2, spot3, spot4};
    
    //Finding second Row of new Matrix
    spot1 = (row2A[0]*row1B[0]) + (row2A[1]*row2B[0]) + (row2A[2]*row3B[0]) + (row2A[3]*row4B[0]);
    spot2 = (row2A[0]*row1B[1]) + (row2A[1]*row2B[1]) + (row2A[2]*row3B[1]) + (row2A[3]*row4B[1]);
    spot3 = (row2A[0]*row1B[2]) + (row2A[1]*row2B[2]) + (row2A[2]*row3B[2]) + (row2A[3]*row4B[2]);
    spot4 = (row2A[0]*row1B[3]) + (row2A[1]*row2B[3]) + (row2A[2]*row3B[3]) + (row2A[3]*row4B[3]);
    float[] row2C = {spot1, spot2, spot3, spot4};
    
    //Finding third Row of new Matrix
    spot1 = (row3A[0]*row1B[0]) + (row3A[1]*row2B[0]) + (row3A[2]*row3B[0]) + (row3A[3]*row4B[0]);
    spot2 = (row3A[0]*row1B[1]) + (row3A[1]*row2B[1]) + (row3A[2]*row3B[1]) + (row3A[3]*row4B[1]);
    spot3 = (row3A[0]*row1B[2]) + (row3A[1]*row2B[2]) + (row3A[2]*row3B[2]) + (row3A[3]*row4B[2]);
    spot4 = (row3A[0]*row1B[3]) + (row3A[1]*row2B[3]) + (row3A[2]*row3B[3]) + (row3A[3]*row4B[3]);
    float[] row3C = {spot1, spot2, spot3, spot4};
    
    //Finding fourth Row of new Matrix
    spot1 = (row4A[0]*row1B[0]) + (row4A[1]*row2B[0]) + (row4A[2]*row3B[0]) + (row4A[3]*row4B[0]);
    spot2 = (row4A[0]*row1B[1]) + (row4A[1]*row2B[1]) + (row4A[2]*row3B[1]) + (row4A[3]*row4B[1]);
    spot3 = (row4A[0]*row1B[2]) + (row4A[1]*row2B[2]) + (row4A[2]*row3B[2]) + (row4A[3]*row4B[2]);
    spot4 = (row4A[0]*row1B[3]) + (row4A[1]*row2B[3]) + (row4A[2]*row3B[3]) + (row4A[3]*row4B[3]);
    float[] row4C = {spot1, spot2, spot3, spot4};
    
    float[][] c = {row1C, row2C, row3C, row4C};
    
    matrix = c;
  }
  
  public Vector applyMatrixTransform(Vector p) {
    float[][] ctm = matrix; //<>//
    return new Vector((ctm[0][0] * p.x) + (ctm[0][1] * p.y) + (ctm[0][2] * p.z) + (ctm[0][3] * 1), (ctm[1][0] * p.x) + (ctm[1][1] * p.y) + (ctm[1][2] * p.z) + (ctm[1][3] * 1),  (ctm[2][0] * p.x) + (ctm[2][1] * p.y) + (ctm[2][2] * p.z) + (ctm[2][3] * 1)); 
  }
}
