class Input {
  String[] text = new String[] {
    "",
    "",
    ""
  };
  int selectedBox;
  InputMode inputMode;
  Grid grid;
  
  ArrayList<PVector> vectors;
  ArrayList<Plane> planes;
  ArrayList<Line> lines;
  
  Input(Grid grid) {
    this.selectedBox = 0;
    this.inputMode = InputMode.VECTOR;
    this.vectors = new ArrayList<PVector>();
    this.planes = new ArrayList<Plane>();
    this.lines = new ArrayList<Line>();
    this.grid = grid;
  }
  
  void show() {
    noStroke();
    textSize(50);
    textAlign(CENTER, CENTER);
    
    // Drawing boxes
    fill(200);
    stroke(255);
    strokeWeight(3);
    rect(0, height - height / 10f, width, height);
    rect(width * 0.25f, height - height / 10f, width, height);
    rect(width * 0.50f, height - height / 10f, width, height);
    rect(width * 0.75f, height - height / 10f, width, height);
    noStroke();
    fill(180);
    rect(0, 0, width / 5f, height * 0.9f);
    fill(50);
    rect(width / 4 * selectedBox, height - height / 10f, width / 4f, height / 10f);
    
    
    // Bottom bar text
    fill(255);
    String modeText;
    if (inputMode == InputMode.VECTOR) modeText = "Mode: Vector";
    else if (inputMode == InputMode.LINE) modeText = "Mode: Line";
    else modeText = "Mode: Plane";
    text(modeText, width / 4 * 3 + width / 8, height - height / 20f);
    text(text[0], width / 8f, height - height / 20f);
    text(text[1], width / 4f + width / 8f, height - height / 20f);
    text(text[2], width / 2f + width / 8f, height - height / 20f);
    
    // Sidebar text
    textAlign(LEFT, CENTER);
    
    text("Vectors", 10, 25);
    for (int i = 0; i < vectors.size(); i++) {
      text(i + ": " + vectors.get(i).toString(), 10, i * 50 + 75);
    }
    
    text("Lines", 10, 50 * vectors.size() + 75);
    for (int i = 0; i < lines.size(); i++) {
      text(i + ":", 10, vectors.size() * 50 + 125 + i * 150);
      for (int j = 0; j < 2; j++) {
        text(lines.get(i).vectors[j].toString(), 10, vectors.size() * 50 + 175 + i * 150 + j * 50);
      }
    }
    
    text("Planes", 10, 50 * vectors.size() + 125 + 150 * lines.size());
    for (int i = 0; i < planes.size(); i++) {
      text(i + ":", 10, vectors.size() * 50 + 175 + i * 200 + 150 * lines.size());
      for (int j = 0; j < 3; j++) {
        text(planes.get(i).vectors[j].toString(), 10, vectors.size() * 50 + 225 + i * 200 + j * 50 + 150 * lines.size());
      }
    }
  }
  
  void switchMode(Press press) {
    if (press == Press.UP) {
      if (inputMode == InputMode.VECTOR) {
        inputMode = InputMode.PLANE;
      }
      
      else if (inputMode == InputMode.LINE) {
        inputMode = InputMode.VECTOR;
      }
      
      else {
        inputMode = InputMode.LINE;
      }
    }
    
    if (press == Press.DOWN) {
      if (inputMode == InputMode.VECTOR) {
        inputMode = InputMode.LINE;
      }
      
      else if (inputMode == InputMode.LINE) {
        inputMode = InputMode.PLANE;
      }
      
      else {
        inputMode = InputMode.VECTOR;
      }
    }
    
    
    
    for (int i = 0; i < 3; i++) {
      text[i] = "";
    }
  }
  
  void enterPressed() {
    if (inputMode == InputMode.VECTOR) {
      vectors.add(new PVector(
        Float.parseFloat(text[0]),
        Float.parseFloat(text[1]),
        Float.parseFloat(text[2])
      ));
    }
    
    else if (inputMode == InputMode.LINE) {
      lines.add(new Line(new PVector[] {
        vectors.get(Integer.parseInt(text[0])),
        vectors.get(Integer.parseInt(text[1])),
      }, grid));
    }
    
    else {
      planes.add(new Plane(new PVector[] {
        vectors.get(Integer.parseInt(text[0])),
        vectors.get(Integer.parseInt(text[1])),
        vectors.get(Integer.parseInt(text[2]))
      }, grid));
    }
    
    for (int i = 0; i < 3; i++) {
      text[i] = "";
    }
  }
  
  void appendString(String string) {
    if (inputMode == InputMode.PLANE) {
      if (string != "-" && string != "." && Integer.parseInt(string) < vectors.size()) text[selectedBox] = string;
    }
    
    else if (inputMode == InputMode.LINE) {
      if (selectedBox != 2 && string != "-" && string != "." && Integer.parseInt(string) < vectors.size()) text[selectedBox] = string;
    }
    
    else {
      if (string == "-" && text[selectedBox] == "") text[selectedBox] += string;
      else if (string == "." && !text[selectedBox].contains(".")) text[selectedBox] += string;
      else if (string != "-" && string != ".") text[selectedBox] += string;
    }
  }
  
  void delete() {
    text[selectedBox] = "";
  }
  
  void mousePressed() {
    if (mouseY >= height - height / 10f) {
      if (mouseX <= width / 4) selectedBox = 0;
      else if (mouseX > width / 4 && mouseX <= width / 2) selectedBox = 1;
      else if (mouseX <= width / 4 * 3) selectedBox = 2;
    }
  }
}

enum InputMode {
  VECTOR,
  LINE,
  PLANE
}

enum Press {
  UP,
  DOWN
}
