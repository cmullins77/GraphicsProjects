class MatrixStack {
  
  ArrayList<Float[][]> matrixStack;
  //Initializes the stack with an identity Matrix
  MatrixStack() {
    matrixStack = new ArrayList<Float[][]>();
    Float[][] newMatrix = {{1f,0f,0f},{0f,1f,0f},{0f,0f,1f}};
    matrixStack.add(newMatrix);
  }
  
  //Duplicates the current CTM and adds it to the top of the stack
  void gtPushMatrix() {
    Float[][] newCTM = matrixStack.get(matrixStack.size()-1);
    matrixStack.add(newCTM);
  }
  
  //Removes the current top of the stack (unless it is the only matrix left)
  void gtPopMatrix() {
      int num = matrixStack.size() - 1;
      if (num == 0) {
          println("cannot pop the matrix stack");
      } else {
          Float[][] oldCTM = matrixStack.get(num);
          matrixStack.remove(oldCTM);
      }
   }
   
   //Creates a Translation matrix and multiplies it with the current CTM
   void gtTranslate(Float x, Float y) {
      Float[][] translateMatrix = {{1f,0f,x},{0f,1f,y},{0f,0f,1f}};
      Float[][] currentCTM = matrixStack.get(matrixStack.size() -1);
      matrixStack.add(multiplyMatrix(currentCTM,translateMatrix));
   }
   
   //Creates a Scaling matrix and multiplies it with the current CTM
   void gtScale(Float x, Float y) {
      Float[][] scaleMatrix = {{x,0f,0f},{0f,y,0f},{0f,0f,1f}};
      Float[][] currentCTM = matrixStack.get(matrixStack.size()-1);
      matrixStack.add(multiplyMatrix(currentCTM,scaleMatrix));
   }
   
   //Creates a Rotation matrix and multiplies it with the current CTM
   void gtRotate(float theta) {
      theta = theta * (PI/180.0);
      Float[][] rotateMatrix = {{cos(theta),-sin(theta),0f},{sin(theta),cos(theta),0f},{0f,0f,1f}};
      Float[][] currentCTM = matrixStack.get(matrixStack.size()-1);
      matrixStack.add(multiplyMatrix(currentCTM,rotateMatrix));
   }
   
   //Creates a Scaling matrix and multiplies it with the current CTM
   void gtSheer(Float x, Float y) {
      Float[][] sheerMatrix = {{1f,x,0f},{y,1f,0f},{0f,0f,1f}};
      Float[][] currentCTM = matrixStack.get(matrixStack.size()-1);
      matrixStack.add(multiplyMatrix(currentCTM,sheerMatrix));
   }
   
   //Creates a Scaling matrix and multiplies it with the current CTM
   void gtPerspective(Float x, Float y) {
      Float[][] perspMatrix = {{1f,0f,0f},{0f,1f,0f},{x,y,1f}};
      Float[][] currentCTM = matrixStack.get(matrixStack.size()-1);
      matrixStack.add(multiplyMatrix(currentCTM,perspMatrix));
   }
   
   //Prints Current CTM
   void printCTM() {
      println(matrixStack.get(matrixStack.size() - 1)[0]);
      println(matrixStack.get(matrixStack.size() - 1)[1]);
      println(matrixStack.get(matrixStack.size() - 1)[2]);
      println("");
   }
   
  //Multiplies 2 Matrices and Returns result
  Float[][] multiplyMatrix(Float[][]a,Float[][]b) {
    //Separating Rows of First Matrix
    Float[] row1A = a[0];
    Float[] row2A = a[1];
    Float[] row3A = a[2];
    
    //Separating Rows of Second Matrix
    Float[] row1B = b[0];
    Float[] row2B = b[1];
    Float[] row3B = b[2];
    
    //Finding first Row of new Matrix
    Float spot1 = (row1A[0]*row1B[0]) + (row1A[1]*row2B[0]) + (row1A[2]*row3B[0]);
    Float spot2 = (row1A[0]*row1B[1]) + (row1A[1]*row2B[1]) + (row1A[2]*row3B[1]);
    Float spot3 = (row1A[0]*row1B[2]) + (row1A[1]*row2B[2]) + (row1A[2]*row3B[2]);
    Float[] row1C = {spot1, spot2, spot3};
    
    //Finding second Row of new Matrix
    spot1 = (row2A[0]*row1B[0]) + (row2A[1]*row2B[0]) + (row2A[2]*row3B[0]);
    spot2 = (row2A[0]*row1B[1]) + (row2A[1]*row2B[1]) + (row2A[2]*row3B[1]);
    spot3 = (row2A[0]*row1B[2]) + (row2A[1]*row2B[2]) + (row2A[2]*row3B[2]);
    Float[] row2C = {spot1, spot2, spot3};
    
    //Finding third Row of new Matrix
    spot1 = (row3A[0]*row1B[0]) + (row3A[1]*row2B[0]) + (row3A[2]*row3B[0]);
    spot2 = (row3A[0]*row1B[1]) + (row3A[1]*row2B[1]) + (row3A[2]*row3B[1]);
    spot3 = (row3A[0]*row1B[2]) + (row3A[1]*row2B[2]) + (row3A[2]*row3B[2]);
    Float[] row3C = {spot1, spot2, spot3};
    
    Float[][] finalMatrix = {row1C, row2C, row3C};
    return finalMatrix;
  }
  
  
  //returns the current ctm
  Float[][] getCTM() {
      return matrixStack.get(matrixStack.size() - 1);
  }
}
