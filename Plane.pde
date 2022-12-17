class Plane {
  PVector[] vectors;
  PVector[] verteces;
  
  Plane(PVector[] vectors, Grid grid) {
    this.vectors = new PVector[] {
      new PVector(vectors[0].x, vectors[0].y, vectors[0].z),
      new PVector(vectors[1].x, vectors[1].y, vectors[1].z),
      new PVector(vectors[2].x, vectors[2].y, vectors[2].z),
    };
    this.verteces = new PVector[(grid.size * 2 + 1) * (grid.size * 2 + 1)];
    
    
    for (int row = 0; row < grid.size * 2 + 1; row++) {
      for (int column = 0; column < grid.size * 2 + 1; column++) {
        verteces[(grid.size * 2 + 1) * row + column] = lineIntersect(new PVector(column - grid.size, 0, grid.size - row));
      }
    }
  }
  
  // Vector represents the location of the vertical line
  PVector lineIntersect(PVector vector) {
    
    // Plane = vectors[0] + a * vectors[1] + b * vectors[2]
    float divideBy = vectors[1].x * vectors[2].z - vectors[2].x * vectors[1].z;
    float a = - ( (vectors[0].x - vector.x) * vectors[2].z - vectors[2].x * vectors[0].z + vector.z * vectors[2].x ) / divideBy;
    float b = ( (vectors[0].x - vector.x) * vectors[1].z - vectors[1].x * vectors[0].z + vector.z * vectors[1].x ) / divideBy;
    
    return new PVector(vector.x, vectors[0].y + vectors[1].y * a + vectors[2].y * b, vector.z);
  }
}
