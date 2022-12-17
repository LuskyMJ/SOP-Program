class Grid {
  int size;
  ArrayList<PVector> verteces;
  
  Grid(int size) {
    this.size = size;
    this.verteces = new ArrayList<PVector>();
    
    for (int row = 0; row < size * 2 + 1; row++) {
      for (int column = 0; column < size * 2 + 1; column++) {
        verteces.add(new PVector(column - size, 0, size - row));
      }
    }
    
    for (int gridHeight = -size; gridHeight < size + 1; gridHeight++) {
      verteces.add(new PVector(0, gridHeight, 0));
    }
  }
}
