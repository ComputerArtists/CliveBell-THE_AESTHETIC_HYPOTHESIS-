// Reaction-Diffusion – Gray-Scott Modell
// Selbstorganisierte Muster

int w = 200; // Rasterbreite
int h = 200; // Rasterhöhe
float[][] a;
float[][] b;
float[][] aNext;
float[][] bNext;

float dA = 1.0;
float dB = 0.5;
float feed = 0.055;
float kill = 0.062;
float dt = 1.0;

void setup() {
  size(800, 800);
  a = new float[w][h];
  b = new float[w][h];
  aNext = new float[w][h];
  bNext = new float[w][h];

  // Anfangswerte
  for (int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      a[i][j] = 1;
      b[i][j] = 0;
    }
  }

  // Initialer Block B in der Mitte
  for (int i = w/2-5; i < w/2+5; i++) {
    for (int j = h/2-5; j < h/2+5; j++) {
      b[i][j] = 1;
    }
  }
}

void draw() {
  background(0);

  // Berechne nächsten Zustand
  for (int x = 1; x < w-1; x++) {
    for (int y = 1; y < h-1; y++) {
      float aC = a[x][y];
      float bC = b[x][y];

      float lapA = laplacianA(x, y);
      float lapB = laplacianB(x, y);

      aNext[x][y] = aC + (dA * lapA - aC*bC*bC + feed*(1-aC))*dt;
      bNext[x][y] = bC + (dB * lapB + aC*bC*bC - (kill + feed)*bC)*dt;

      aNext[x][y] = constrain(aNext[x][y], 0, 1);
      bNext[x][y] = constrain(bNext[x][y], 0, 1);
    }
  }

  // Swap Arrays
  float[][] tempA = a; a = aNext; aNext = tempA;
  float[][] tempB = b; b = bNext; bNext = tempB;

  // Zeichne Muster
  loadPixels();
  for (int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      int pixX = i * width/w;
      int pixY = j * height/h;
      float c = (a[i][j] - b[i][j])*255;
      c = constrain(c,0,255);
      for (int dx=0; dx<width/w; dx++) {
        for (int dy=0; dy<height/h; dy++) {
          int loc = (pixX+dx) + (pixY+dy)*width;
          pixels[loc] = color(c, 255-c, 180);
        }
      }
    }
  }
  updatePixels();
}

// Laplace-Operatoren
float laplacianA(int x, int y) {
  float sum = 0;
  sum += a[x][y]*-1;
  sum += a[x-1][y]*0.2;
  sum += a[x+1][y]*0.2;
  sum += a[x][y-1]*0.2;
  sum += a[x][y+1]*0.2;
  sum += a[x-1][y-1]*0.05;
  sum += a[x+1][y-1]*0.05;
  sum += a[x+1][y+1]*0.05;
  sum += a[x-1][y+1]*0.05;
  return sum;
}

float laplacianB(int x, int y) {
  float sum = 0;
  sum += b[x][y]*-1;
  sum += b[x-1][y]*0.2;
  sum += b[x+1][y]*0.2;
  sum += b[x][y-1]*0.2;
  sum += b[x][y+1]*0.2;
  sum += b[x-1][y-1]*0.05;
  sum += b[x+1][y-1]*0.05;
  sum += b[x+1][y+1]*0.05;
  sum += b[x-1][y+1]*0.05;
  return sum;
}

// --- Mausinteraktion: setze B lokal ---
void mouseDragged() {
  int i = int(map(mouseX,0,width,0,w));
  int j = int(map(mouseY,0,height,0,h));
  for (int x = i-3; x <= i+3; x++) {
    for (int y = j-3; y <= j+3; y++) {
      if (x>0 && x<w && y>0 && y<h) {
        b[x][y] = 1;
      }
    }
  }
}

// Taste s = speichern
void keyPressed() {
  if (key == 's') {
    saveFrame("mack-farbig-####.png");
    println("gespeichert");
  }
}
