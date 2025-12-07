// ------------------------------------------------------
// FUTURISTIC NEON CITY – FULL EDITION
// ------------------------------------------------------

float scroll = 0;
ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  size(1100, 700, P3D);
  smooth(8);

  // viele Partikel laden
  for (int i = 0; i < 250; i++) {
    particles.add(new Particle());
  }
}

void draw() {
  background(5);

  // Kamera leicht bewegen für futuristisches "Hover"-Feeling
  float camX = width/2 + sin(frameCount * 0.01) * 60;
  float camY = height/3 + cos(frameCount * 0.013) * 40;

  camera(camX, camY, 650,
         width/2, height/2, 0,
         0, 1, 0);

  lights();

  // futuristischer Farbmodus
  colorMode(HSB, 360, 100, 100);

  drawGrid();
  drawParticles();
  drawHologramCubes();
  drawScanlines();

  scroll += 6;
}

// ------------------------------------------------------
// GLOWING NEON GRID
// ------------------------------------------------------
void drawGrid() {
  strokeWeight(2);

  for (int z = -3000; z < 2000; z += 50) {
    float glow = map(z, -3000, 2000, 30, 100);

    stroke(180, 100, glow); // neon cyan
    beginShape();
    for (int x = -1500; x < 1500; x += 50) {
      float zz = z + scroll % 50;
      vertex(width/2 + x, height/2 + 250, zz);
    }
    endShape();
  }
}

// ------------------------------------------------------
// HOLOGRAM CUBES – floating, rotating, glowing
// ------------------------------------------------------
void drawHologramCubes() {
  for (int i = 0; i < 6; i++) {
    pushMatrix();

    float t = frameCount * 0.01 + i;
    float x = width/2 + sin(t * 1.2) * 300;
    float y = height/2 - 150 + sin(t * 0.7) * 70;
    float z = -300 - i * 300;

    translate(x, y, z);

    rotateX(t * 0.8);
    rotateY(t * 1.1);

    noFill();

    strokeWeight(2);
    stroke(300, 100, 100, 80);   // neon magenta
    box(120);

    // Glow-Effekt
    stroke(300, 100, 100, 30);
    box(140);

    popMatrix();
  }
}

// ------------------------------------------------------
// PARTICLE STREAMS – digital data packets
// ------------------------------------------------------
class Particle {
  PVector pos;
  PVector vel;
  float life;

  Particle() {
    respawn();
  }

  void respawn() {
    pos = new PVector(width/2, random(height/2 - 200, height/2 + 200), random(-500, -2000));
    vel = new PVector(random(-1, 1), random(-0.3, 0.3), random(6, 10));
    life = random(50, 140);
  }

  void update() {
    pos.add(vel);
    life--;

    if (life < 0 || pos.z > 200) {
      respawn();
    }
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);

    float brightness = map(life, 0, 140, 20, 100);

    strokeWeight(3);
    stroke(200, 100, brightness, 100);  // bright blue-white

    point(0, 0);
    popMatrix();
  }
}

void drawParticles() {
  for (Particle p : particles) {
    p.update();
    p.display();
  }
}

// ------------------------------------------------------
// SCANLINES – holographic display effect
// ------------------------------------------------------
void drawScanlines() {
  noStroke();
  fill(255, 15); // leicht transparent

  for (int y = 0; y < height; y += 3) {
    rect(0, y, width, 1);
  }
}

// Taste s = speichern
void keyPressed() {
  if (key == 's') {
    saveFrame("mack-farbig-####.png");
    println("gespeichert");
  }
}
