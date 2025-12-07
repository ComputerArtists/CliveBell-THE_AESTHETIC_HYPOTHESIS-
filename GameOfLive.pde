// Conway's Game of Life – Zellulärer Automat
// Interaktiv: Klick auf Zellen, Space = Start/Stop

int cols, rows;
int cellSize = 10;
boolean[][] grid;
boolean[][] nextGrid;

boolean running = false;

void setup() {
  size(800, 600);
  frameRate(10);  // 10 Frames pro Sekunde
  cols = width / cellSize;
  rows = height / cellSize;

  grid = new boolean[cols][rows];
  nextGrid = new boolean[cols][rows];

  // zufälliger Startzustand
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j] = random(1) < 0.2;
    }
  }
}

void draw() {
  background(30);

  // Zellen zeichnen
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (grid[i][j]) {
        float hue = map(frameCount%360, 0, 360, 0, 360);
        fill(hue, 80, 90);
        noStroke();
        rect(i*cellSize, j*cellSize, cellSize, cellSize);
      }
    }
  }

  // Automaton nur aktualisieren, wenn running
  if (running) {
    updateGrid();
  }
}

void updateGrid() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int neighbors = countNeighbors(i, j);

      if (grid[i][j]) {
        // Überleben: 2 oder 3 Nachbarn
        nextGrid[i][j] = neighbors == 2 || neighbors == 3;
      } else {
        // Geburt: genau 3 Nachbarn
        nextGrid[i][j] = neighbors == 3;
      }
    }
  }

  // nextGrid kopieren
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j] = nextGrid[i][j];
    }
  }
}

int countNeighbors(int x, int y) {
  int sum = 0;
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      int col = (x + i + cols) % cols;
      int row = (y + j + rows) % rows;
      if (!(i == 0 && j == 0) && grid[col][row]) {
        sum++;
      }
    }
  }
  return sum;
}

// --- Interaktion ---
void mousePressed() {
  int i = mouseX / cellSize;
  int j = mouseY / cellSize;
  if (i >= 0 && i < cols && j >= 0 && j < rows) {
    grid[i][j] = !grid[i][j]; // Zelle umschalten
  }
}

void keyPressed() {
  if (key == ' ') {
    running = !running; // Start/Stop
  } else if (key == 'c' || key == 'C') {
    // Alles zurücksetzen
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j] = false;
      }
    }
  }
    if (key == 's') {
    saveFrame("mack-farbig-####.png");
    println("gespeichert");
  }
}
