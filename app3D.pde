Camera camera;
ArrayList<Mesh> meshes;
Grid grid;
Input input;
float movementSpeed = 0.01f;
float cameraSpeed = 0.00075f;

// Deltatime
int time = 0;
int deltaTime = 0;

// Preview
Mesh mesh;
float rotation = 0f;
float rotationSpeed = 0.001f;

void setup() {
  deltaTime = millis() - time;
  camera = new Camera(new PVector(0, 0, 0), new PVector(0, 0, 0), 90f, 60f, 0.1f, 100f);
  meshes = new ArrayList<Mesh>();
  grid = new Grid(10);
  input = new Input(grid);
    
  mesh = new Mesh(new PVector[] {
      new PVector(-0.5f, 0.5f, 0.5f),
      new PVector(0.5f, 0.5f, 0.5f),
      new PVector(0.5f, -0.5f, 0.5),
      new PVector(-0.5f, -0.5f, 0.5),
      new PVector(-0.5f, 0.5f, -0.5f),
      new PVector(0.5f, 0.5f, -0.5f),
      new PVector(0.5f, -0.5f, -0.5),
      new PVector(-0.5f, -0.5f, -0.5)
    }, 
    new PVector[] {
      new PVector(0, 1, 2),
      new PVector(2, 3, 0),
      new PVector(4, 5, 1),
      new PVector(1, 0, 4),
      new PVector(4, 0, 3),
      new PVector(3, 7, 4),
      new PVector(3, 2, 6),
      new PVector(6, 7, 3),
      new PVector(1, 5, 6),
      new PVector(6, 2, 1),
      new PVector(4, 5, 6),
      new PVector(6, 7, 4)   
  }).setTranslation(new PVector(-2, 2, 2));
  meshes.add(mesh);  

  
  noFill(); 
  size(1920, 1080);
  fullScreen();
  background(0);
  stroke(255);
  fill(255);
}

void draw() {
  deltaTime = millis() - time;
  
  background(0);
  rotation += deltaTime * rotationSpeed;
  mesh.setRotation(new PVector(rotation, rotation, rotation));
  
  input.show();
  camera.render(RenderMode.LINE, grid, meshes, input.vectors, input.lines, input.planes);
  
  time = millis();
}

Matrix fromVector(PVector vector) {
  return new Matrix(4, 1).setMatrix(
    new float[][] {
      {vector.x, vector.y, vector.z, 1}
    }
  );
}

void keyPressed() {
  // println("KEYCODE: " + keyCode);
  // 80 = p
  // 87 = w
  // 83 = s
  // 65 = a
  // 68 = d
  // 10 = space
  
  if (keyCode == 87) {
    camera.move(camera.forward().mult(movementSpeed).mult(deltaTime));
  }
  
  else if (keyCode == 83) {
    camera.move(camera.forward().mult(-1).mult(movementSpeed).mult(deltaTime));
  }
  
  else if (keyCode == 65) {
    camera.move(camera.right().mult(movementSpeed).mult(-1).mult(deltaTime));
  }
  
  else if (keyCode == 68) {
    camera.move(camera.right().mult(movementSpeed).mult(deltaTime));
  }
  
  else if (keyCode == UP) input.switchMode(Press.UP);
  else if (keyCode == DOWN) input.switchMode(Press.DOWN);
  
  // Input field
  if (keyCode == 32) input.appendString(" ");
  else if (keyCode == 48) input.appendString("0");
  else if (keyCode == 49) input.appendString("1");
  else if (keyCode == 50) input.appendString("2");
  else if (keyCode == 51) input.appendString("3");
  else if (keyCode == 52) input.appendString("4");
  else if (keyCode == 53) input.appendString("5");
  else if (keyCode == 54) input.appendString("6");
  else if (keyCode == 55) input.appendString("7");
  else if (keyCode == 56) input.appendString("8");
  else if (keyCode == 57) input.appendString("9");
  else if (keyCode == 45) input.appendString("-");
  else if (keyCode == 46) input.appendString(".");
  else if (keyCode == 8) input.delete();
  else if(keyCode == 10) input.enterPressed();
 
  //println(key);
  //println(keyCode);
}

void mouseDragged() {
  if (mouseButton == RIGHT) {
    camera.rotation.y += (mouseX - pmouseX) * cameraSpeed * deltaTime;
    camera.rotation.x += (mouseY - pmouseY) * cameraSpeed * deltaTime;
  }
}

void mousePressed() {
  input.mousePressed();
}
