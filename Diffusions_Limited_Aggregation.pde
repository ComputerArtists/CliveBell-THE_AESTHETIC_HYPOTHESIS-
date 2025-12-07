// Diffusions-Limited Aggregation – fraktales Wachstum

ArrayList<Particle> particles;
ArrayList<Particle> cluster;

int numParticles = 1000;
float stickDistance = 2.5; // Abstand zum Haften
float speed = 1.5;         // Bewegungsrate der Partikel

void setup() {
  size(800, 800);
  colorMode(HSB, 360, 100, 100);
  background(210, 30, 95);

  particles = new ArrayList<Particle>();
  cluster = new ArrayList<Particle>();

  // Start-Seed in der Mitte
  Particle seed = new Particle(width/2, height/2, true);
  cluster.add(seed);

  // Erzeuge wandernde Partikel am Rand
  for (int i = 0; i < numParticles; i++) {
    particles.add(randomParticle());
  }
}

void draw() {
  // Update Partikel
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.move();
    p.display();

    // Prüfen, ob Partikel am Cluster haftet
    for (Particle c : cluster) {
      float d = dist(p.x, p.y, c.x, c.y);
      if (d < stickDistance) {
        cluster.add(new Particle(p.x, p.y, true));
        particles.remove(i);
        particles.add(randomParticle()); // neues Partikel starten
        break;
      }
    }
  }

  // Cluster zeichnen
  for (Particle c : cluster) {
    c.display();
  }
}

// --- Partikel erzeugen am Rand ---
Particle randomParticle() {
  float x, y;
  float edge = random(1);
  if (edge < 0.25) { x = 0; y = random(height); }
  else if (edge < 0.5) { x = width; y = random(height); }
  else if (edge < 0.75) { x = random(width); y = 0; }
  else { x = random(width); y = height; }

  return new Particle(x, y, false);
}

// --- Partikelklasse ---
class Particle {
  float x, y;
  boolean stuck;
  color c;

  Particle(float _x, float _y, boolean _stuck) {
    x = _x;
    y = _y;
    stuck = _stuck;

    if (stuck) {
      float hueVal = map(dist(x, y, width/2, height/2), 0, width/2, 180, 300);
      c = color(hueVal, 80, 90);
    } else {
      c = color(0,0,100);
    }
  }

  void move() {
    if (!stuck) {
      x += random(-speed, speed);
      y += random(-speed, speed);
      x = constrain(x, 0, width);
      y = constrain(y, 0, height);
    }
  }

  void display() {
    fill(c);
    noStroke();
    ellipse(x, y, 2.5, 2.5);
  }
}

// --- Tastatursteuerung ---
void keyPressed() {
  if (key == 'w' || key == 'W') speed += 0.2; // schneller
  if (key == 's' || key == 'S') speed = max(0.2, speed-0.2); // langsamer
  if (key == 'c' || key == 'C') { // Neustart
    background(210,30,95);
    particles.clear();
    cluster.clear();
    cluster.add(new Particle(width/2, height/2, true));
    for (int i = 0; i < numParticles; i++) {
      particles.add(randomParticle());
    }
  }
  if (key == 's') {
    saveFrame("mack-farbig-####.png");
    println("gespeichert");
  }
}
