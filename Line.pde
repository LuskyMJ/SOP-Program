class Line {
  PVector[] vectors;
  PVector[] points;



  Line(PVector[] vectors, Grid grid) {
    this.vectors = new PVector[] {
      new PVector(vectors[0].x, vectors[0].y, vectors[0].z),
      new PVector(vectors[1].x, vectors[1].y, vectors[1].z),
    };

    ArrayList<PVector> points = new ArrayList<PVector>();
    PVector[] allIntersections = new PVector[4];

    // Intersection with x plane
    float a = (grid.size - vectors[0].x) / vectors[1].x;
    allIntersections[0] = copyVec(vectors[1]).mult(a).add(copyVec(vectors[0]));

    // Intersection with -x plane
    a = (-vectors[0].x - grid.size) / vectors[1].x;
    allIntersections[1] = copyVec(vectors[1]).mult(a).add(copyVec(vectors[0]));

    // Intersection with z plane
    a = (grid.size - vectors[0].z) / vectors[1].z;
    allIntersections[2] = copyVec(vectors[1]).mult(a).add(copyVec(vectors[0]));


    // Intersection with -z plane
    a = (-vectors[0].z - grid.size) / vectors[1].z;
    allIntersections[3] = copyVec(vectors[1]).mult(a).add(copyVec(vectors[0]));

    // Checking which points to use
    if (allIntersections[0].z <= grid.size && allIntersections[0].z >= -grid.size) {
      points.add(allIntersections[0]);
    }

    if (allIntersections[1].z <= grid.size && allIntersections[1].z >= -grid.size) {
      points.add(allIntersections[1]);
    }

    if (allIntersections[2].x <= grid.size && allIntersections[2].x >= -grid.size) {
      points.add(allIntersections[2]);
    }

    if (allIntersections[3].x <= grid.size && allIntersections[3].x >= -grid.size) {
      points.add(allIntersections[3]);
    }

    this.points = points.toArray(new PVector[points.size()]);
  }

  PVector copyVec(PVector vector) {
    return new PVector(vector.x, vector.y, vector.z);
  }
}
