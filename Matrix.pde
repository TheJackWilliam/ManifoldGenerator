class Matrix {
  int numRows, numCols;
  float[][] matrix;
  float lerpVal = 0;
  Matrix(int rows, int cols) {
    numRows = rows; numCols = cols;
    
    matrix = new float[rows][cols];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        matrix[r][c] = random(4) - 2; //0.0; // -------------------- Maybe set this to a random float -------------------- //
      }
    }
  }
  
  void clear() {
    for (int row = 0; row < numRows; row++) {
      for (int col = 0; col < numCols; col++) {
        matrix[row][col] = 0;
      }
    }
  }
  
  void set(Matrix input) {
    if (numRows != input.numRows || numCols != input.numCols) {
      println("Matrix::set() => Dimensions Incompatable!");
      return;
    }
    
    for (int row = 0; row < numRows; row++) {
      for (int col = 0; col < numCols; col++) {
        matrix[row][col] = input.matrix[row][col];
      }
    }
  }
  
  void set(float[][] input) {
    if (numRows != input.length || numCols != input[0].length) {
      println("Matrix::set() => Dimensions Incompatable!");
      return;
    }
    
    for (int row = 0; row < numRows; row++) {
      for (int col = 0; col < numCols; col++) {
        matrix[row][col] = input[row][col];
      }
    }
  }
  
  Matrix add(Matrix input) {
    if (numRows != input.numRows || numCols != input.numCols) {
      println("Matrix::add() => Dimensions Incompatable!");
      return new Matrix(0, 0);
    }
    
    Matrix output = new Matrix(numRows, numCols);
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        output.matrix[r][c] = lerp(0, matrix[r][c], lerpVal) + input.matrix[r][c];
      }
    }
    return output;
  }
  
  Matrix mult(Matrix input) { // 2D
    if (numCols != input.numRows) {
      println("Matrix::mult() => Dimensions Incompatable!");
      return new Matrix(0, 0);
    }
    
    Matrix output = new Matrix(numRows, input.numCols);
    for (int input_col = 0; input_col < input.numCols; input_col++) {
      for (int row = 0; row < numRows; row++) { 
        float sum = 0;
        for (int col = 0; col < numCols; col++) {
          sum += lerp((row == col ? 1 : 0), matrix[row][col], lerpVal) * input.matrix[col][input_col];
        }
        output.matrix[row][input_col] = sum;
      }
    }
    return output;
  }
  
  void applySigmoid() {
    for (int row = 0; row < numRows; row++) { 
      for (int col = 0; col < numCols; col++) {
        // matrix[row][col] = lerp(matrix[row][col], sigmoid(matrix[row][col]), lerpVal);
        matrix[row][col] = sigmoid(matrix[row][col]);
      }
    }
  }
  
  void incrementLerp(float sec) { // display time
    lerpVal += 1.0/(60*sec);
  }
}


float sigmoid(float x) {
  return pow(1 + exp(-x), -1);
}
