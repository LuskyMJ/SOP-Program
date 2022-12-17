class Matrix {
  float[][] matrix;
  public int columns, rows;
  
  Matrix(int rows, int columns) {
    this.rows = rows;
    this.columns = columns;
    this.matrix = new float[columns][rows];
  }
  
  public Matrix setMatrix(float[][] matrix) {
    this.matrix = matrix;
    return this;
  }
  
  public Matrix multiply(Matrix otherMatrix) {
    Matrix productMatrix = new Matrix(rows, otherMatrix.columns);
    
    if (columns != otherMatrix.rows) {
      println("Can't multiply matrices");
    }
    
    else {
      for (int columnIndex = 0; columnIndex < otherMatrix.columns; columnIndex++) {
        float[] newColumn = new float[rows];
        for (int rowIndex = 0; rowIndex < rows; rowIndex++) {
          for (int i = 0; i < columns; i++) {
            newColumn[rowIndex] += matrix[i][rowIndex] * otherMatrix.matrix[columnIndex][i];
          }
        }
        productMatrix.setColumn(columnIndex, newColumn);
      }
    }
    
    return productMatrix;
  }
  
  public Matrix divide(float number) {
    for (int columnIndex = 0; columnIndex < columns; columnIndex++) {
      for (int rowIndex = 0; rowIndex < rows; rowIndex++) {
        matrix[columnIndex][rowIndex] /= number;
      }
    }
    
    return this;
  }
  
  private void setColumn(int columnIndex, float[] columnContent) {
    matrix[columnIndex] = columnContent;
  }
  
  public void printMatrix() {
    for (int rowIndex = 0; rowIndex < rows; rowIndex++) {
      for (int columnIndex = 0; columnIndex < columns; columnIndex++) {
          print(matrix[columnIndex][rowIndex] + "|");
      }
      println();
    }
    println();
  }
  
  PVector toVector() {
    if (matrix[0][2] != 0) return new PVector(matrix[0][0], matrix[0][1], matrix[0][2]);
    else return new PVector(this.matrix[0][0], this.matrix[0][1]);
  }
}
