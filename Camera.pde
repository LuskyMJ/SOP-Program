class Camera {
  private PVector translation, rotation;
  private float fovX, fovY;
  private float zNear, zFar;

  Camera(PVector translation, PVector rotation, float fovX, float fovY, float zNear, float zFar) {
    this.translation = translation;
    this.rotation = rotation;
    this.fovX = fovX;
    this.fovY = fovY;
    this.zNear = zNear;
    this.zFar = zFar;
  }

  public void setTranslation(PVector translation) {
    this.translation = translation;
  }

  public void setRotation(PVector rotation) {
    this.rotation = rotation;
  }
  
  public void setFovX(float x) {
    this.fovX = x;
  }
  
  public void setFovY(float y) {
    this.fovY = y;
  }
  
  void move(PVector movement) {
    translation.add(movement);
  }
  
  public PVector forward() {
    return new PVector(
      cos(rotation.x) * sin(rotation.y),
      -sin(rotation.x),
      cos(rotation.x) * cos(rotation.y)
    );
  }
  
  public PVector right() {
    return new PVector(
      cos(rotation.y),
      0,
      -sin(rotation.y)
    );
  }
    
  public void showInfo() {
    textAlign(RIGHT, CENTER);
    textSize(50);
    text("Pos: " + translation.toString(), width - 10, 50);
    text("Rot: " + rotation.toString(), width - 10, 100);
    text("FovX: " + fovX, width - 10, 150);
    text("FovY: " + fovY, width - 10, 200);
    text("Forward: " + forward().toString(), width - 10, 250);
  }

  public void render(RenderMode renderMode, Grid grid, ArrayList<Mesh> meshes, ArrayList<PVector> vectors, ArrayList<Line> lines, ArrayList<Plane> planes) {
    strokeWeight(3);
    stroke(255);
    fill(255);


    // Meshes
    for (Mesh mesh : meshes) {
      Matrix[] verteces = new Matrix[mesh.verteces.length];
      
      // Converting every vertex in Mesh to viewSpace
      for (int vertex = 0; vertex < verteces.length; vertex++) {
        verteces[vertex] = fromVector(mesh.verteces[vertex]);
        verteces[vertex] = modelToWorldSpace(verteces[vertex], mesh);
        verteces[vertex] = worldToViewSpace(verteces[vertex]);
        verteces[vertex] = viewToProjectionSpace(verteces[vertex]);
      }
      
      // Culling + drawing
      for (PVector polygon : mesh.polygons) {
        boolean skipPolygon = false;
        PVector[] screenSpacePositions = new PVector[3];
        
        Matrix[] polygonVerteces = new Matrix[] {
          verteces[(int)polygon.x],
          verteces[(int)polygon.y],
          verteces[(int)polygon.z]
        };
        
        for (int i = 0; i < 3; i++) {
          if (!skipPolygon) {
            if (polygonVerteces[i].matrix[0][2] > 1 || polygonVerteces[i].matrix[0][2] < 0) skipPolygon = true;
            else screenSpacePositions[i] = projectionToScreenSpace(polygonVerteces[i]);
          }
        }
        
        
        // The drawing
        if (!skipPolygon) {
          if (renderMode == RenderMode.LINE) {
            line(screenSpacePositions[0].x, screenSpacePositions[0].y, screenSpacePositions[1].x, screenSpacePositions[1].y);
            line(screenSpacePositions[1].x, screenSpacePositions[1].y, screenSpacePositions[2].x, screenSpacePositions[2].y);
            line(screenSpacePositions[2].x, screenSpacePositions[2].y, screenSpacePositions[0].x, screenSpacePositions[0].y);
          }
          else if (renderMode == RenderMode.SOLID) {
          }
        }
        
        circle(width / 2, height / 2, 10);
      }
    }
    
    // Grid
    textSize(20);
    strokeWeight(3);
    for (PVector vertex : grid.verteces) {
      
      Matrix matrix = fromVector(vertex);
      matrix = worldToViewSpace(matrix);
      matrix = viewToProjectionSpace(matrix);

      if (matrix.matrix[0][2] <= 1 && matrix.matrix[0][2] >= 0) {
        PVector screenSpace = projectionToScreenSpace(matrix);
        String text = null;
        
        // On y-axis
        if (vertex.x == 0 && vertex.z == 0) {
          if (vertex.y == grid.size) {
            text = "+y";
          }
          else if (vertex.y == -grid.size) {
            text = "-y";
          }
          else {
            text = str(vertex.y);
          }
        }
        
        // On z-axis
        else if (vertex.x == 0) {
          if (vertex.z == -grid.size) {
            text = "-z";
          }
          else if (vertex.z == grid.size) {
            text = "+z";
          }
          else {
            text = str(vertex.z);
          }
        }
        
        // On x-axis
        else if (vertex.z == 0) {
          if (vertex.x == -grid.size) {
            text = "-x";
          }
          else if (vertex.x == grid.size) {
            text = "+x";
          }
          else {
            text = str(vertex.x);
          }
        }
        
        if (text != null) text(text, screenSpace.x, screenSpace.y);
        else {
          point(screenSpace.x, screenSpace.y);
        }
      } 
    }
    
    // Vectors
    textAlign(CENTER);
    Matrix origo = fromVector(new PVector(0, 0, 0));
    origo = worldToViewSpace(origo);
    origo = viewToProjectionSpace(origo);
    stroke(#0000FF);
    
    if (origo.matrix[0][2] <= 1 && origo.matrix[0][2] >= 0) {
      PVector projectionOrigo = projectionToScreenSpace(origo);
      
      for (PVector vector : vectors) {
        Matrix matrix = fromVector(vector);
        matrix = worldToViewSpace(matrix);
        matrix = viewToProjectionSpace(matrix);
        
        if (matrix.matrix[0][2] <= 1 && matrix.matrix[0][2] >= 0) {
          PVector projection = projectionToScreenSpace(matrix);
          line(projectionOrigo.x, projectionOrigo.y, projection.x, projection.y);
          text(vector.toString(), projection.x, projection.y);
        }
      }
    }
    
    // Lines
    stroke(#FF0000);
    for (Line line : lines) {
      Matrix firstPoint = fromVector(line.points[0]);
      Matrix secondPoint = fromVector(line.points[1]);
      firstPoint = worldToViewSpace(firstPoint);
      firstPoint = viewToProjectionSpace(firstPoint);
      secondPoint = worldToViewSpace(secondPoint);
      secondPoint = viewToProjectionSpace(secondPoint);
      
      if (firstPoint.matrix[0][2] >= 0 && firstPoint.matrix[0][2] <= 1 && secondPoint.matrix[0][2] >= 0 && secondPoint.matrix[0][2] <= 1) {
        PVector firstPointScreen = projectionToScreenSpace(firstPoint);
        PVector secondPointScreen = projectionToScreenSpace(secondPoint);
        text(line.points[0].toString(), firstPointScreen.x, firstPointScreen.y);
        text(line.points[1].toString(), secondPointScreen.x, secondPointScreen.y);
        line(firstPointScreen.x, firstPointScreen.y, secondPointScreen.x, secondPointScreen.y);
      } 
    }
    
    // Planes
    stroke(#00FF00);
    for (Plane plane : planes) {
      for (PVector vertex : plane.verteces) {
        Matrix matrix = fromVector(vertex);
        matrix = worldToViewSpace(matrix);
        matrix = viewToProjectionSpace(matrix);
        
        if (matrix.matrix[0][2] <= 1 && matrix.matrix[0][2] >= 0) {
          PVector projection = projectionToScreenSpace(matrix);
          point(projection.x, projection.y);
        }
        
        
        
      }
    }
  }

  private Matrix modelToWorldSpace(Matrix matrix, Mesh mesh) {

    // Scale
    matrix = new Matrix(4, 4).setMatrix(new float[][] {
      {mesh.scale.x, 0, 0, 0},
      {0, mesh.scale.y, 0, 0},
      {0, 0, mesh.scale.z, 0},
      {0, 0, 0, 1}
      }).multiply(matrix);

    // Rotate
    Matrix rotationMatrix = xRotationMatrix(mesh.rotation.x).multiply(yRotationMatrix(mesh.rotation.y)).multiply(zRotationMatrix(mesh.rotation.z));
    matrix = rotationMatrix.multiply(matrix);

    // Translate
    matrix = new Matrix(4, 4).setMatrix(new float[][] {
      {1, 0, 0, 0},
      {0, 1, 0, 0},
      {0, 0, 1, 0},
      {mesh.translation.x, mesh.translation.y, mesh.translation.z, 1}
      }).multiply(matrix);

    return matrix;
  }

  private Matrix worldToViewSpace(Matrix matrix) {
    Matrix cameraAntiX = xRotationMatrix(-rotation.x);
    Matrix cameraAntiY = yRotationMatrix(-rotation.y);
    Matrix cameraAntiZ = zRotationMatrix(-rotation.z);
    
    Matrix cameraAntiTranslation = new Matrix(4, 4).setMatrix(new float[][] {
      {1, 0, 0, 0},
      {0, 1, 0, 0},
      {0, 0, 1, 0},
      {-translation.x, -translation.y, -translation.z, 1}
      });  
      
    Matrix cameraAntiRotation = cameraAntiX.multiply(cameraAntiY).multiply(cameraAntiZ);
    return cameraAntiRotation.multiply(cameraAntiTranslation).multiply(matrix);
  }

  private Matrix viewToProjectionSpace(Matrix matrix) {
    float xScale = 1 / tan(radians(fovX / 2));
    float yScale = 1 / tan(radians(fovY / 2));
    float zScale = zFar / (zFar - zNear);
    
    Matrix projectionMatrix = new Matrix(4, 4).setMatrix(new float[][] {
      {xScale, 0, 0, 0},
      {0, yScale, 0, 0},
      {0, 0, zScale, 1},
      {0, 0, -zNear * zScale, 0}
    });
   
    matrix = projectionMatrix.multiply(matrix);
    if (matrix.matrix[matrix.columns-1][matrix.rows-1] != 0f) {
      matrix = matrix.divide(matrix.matrix[matrix.columns-1][matrix.rows-1]);
    }
    
    return matrix;
  }

  private PVector projectionToScreenSpace(Matrix matrix) {
    PVector normScreenPos = matrix.toVector();
    return new PVector(normScreenPos.x * (width / 2) + width / 2, -normScreenPos.y * (height / 2) + height / 2 );
  }

  // Rotation matrices
  private Matrix xRotationMatrix(float xRotation) {
    return new Matrix(4, 4).setMatrix(new float[][] {
      {1, 0, 0, 0},
      {0, cos(xRotation), sin(xRotation), 0},
      {0, -sin(xRotation), cos(xRotation), 0},
      {0, 0, 0, 1}
    });
  }

  private Matrix yRotationMatrix(float yRotation) {
    return new Matrix(4, 4).setMatrix(new float[][] {
      {cos(yRotation), 0, -sin(yRotation), 0},
      {0, 1, 0, 0},
      {sin(yRotation), 0, cos(yRotation), 0},
      {0, 0, 0, 1}
    });
  }

  private Matrix zRotationMatrix(float zRotation) {
    return new Matrix(4, 4).setMatrix(new float[][] {
      {cos(zRotation), sin(zRotation), 0, 0},
      {-sin(zRotation), cos(zRotation), 0, 0},
      {0, 0, 1, 0},
      {0, 0, 0, 1}
    });
  }
}

enum RenderMode {
  SOLID,
  LINE
}
