// Predator-Prey / Lotka-Volterra Simulation
// Beute (Kaninchen) vs Räuber (Wölfe)

ArrayList<Prey> preyList;
ArrayList<Predator> predatorList;

int initialPrey = 80;
int initialPredators = 20;

void setup() {
  size(800, 600);
  colorMode(HSB, 360, 100, 100);
  preyList = new ArrayList<Prey>();
  predatorList = new ArrayList<Predator>();

  for (int i = 0; i < initialPrey; i++) {
    preyList.add(new Prey(random(width), random(height)));
  }
  for (int i = 0; i < initialPredators; i++) {
    predatorList.add(new Predator(random(width), random(height)));
  }
}

void draw() {
  background(210, 30, 95);

  // Update Beute
  for (int i = preyList.size()-1; i >= 0; i--) {
    Prey p = preyList.get(i);
    p.move();
    p.display();
    // Reproduktion
    if (random(1) < 0.005) {
      preyList.add(new Prey(p.pos.x, p.pos.y));
    }
  }

  // Update Räuber
  for (int i = predatorList.size()-1; i >= 0; i--) {
    Predator pr = predatorList.get(i);
    pr.hunt(preyList);
    pr.move();
    pr.display();
    pr.energy -= 0.01; // Energieverlust
    if (pr.energy <= 0) predatorList.remove(i);
  }

  // Infoanzeige
  fill(0,0,100);
  textSize(16);
  text("Beute: " + preyList.size(), 10, 20);
  text("Räuber: " + predatorList.size(), 10, 40);
}

// --- Beute-Klasse ---
class Prey {
  PVector pos;
  float speed = 2;
  float size = 6;

  Prey(float x, float y) {
    pos = new PVector(x, y);
  }

  void move() {
    pos.x += random(-speed, speed);
    pos.y += random(-speed, speed);
    pos.x = constrain(pos.x, 0, width);
    pos.y = constrain(pos.y, 0, height);
  }

  void display() {
    fill(100, 80, 90);
    noStroke();
    ellipse(pos.x, pos.y, size, size);
  }
}

// --- Räuber-Klasse ---
class Predator {
  PVector pos;
  float speed = 2.5;
  float size = 10;
  float energy = 3.0;

  Predator(float x, float y) {
    pos = new PVector(x, y);
  }

  void move() {
    pos.x += random(-speed, speed);
    pos.y += random(-speed, speed);
    pos.x = constrain(pos.x, 0, width);
    pos.y = constrain(pos.y, 0, height);
  }

  void hunt(ArrayList<Prey> preyList) {
    for (int i = preyList.size()-1; i >= 0; i--) {
      Prey p = preyList.get(i);
      float d = dist(pos.x, pos.y, p.pos.x, p.pos.y);
      if (d < (size + p.size)/2) {
        preyList.remove(i);
        energy += 0.5; // Energie gewinnen
      }
    }
  }

  void display() {
    fill(0, 80, 90);
    noStroke();
    ellipse(pos.x, pos.y, size, size);
  }
}

// --- Tastatursteuerung ---
void keyPressed() {
  if (key == 'c' || key == 'C') {
    preyList.clear();
    predatorList.clear();
    for (int i = 0; i < initialPrey; i++) preyList.add(new Prey(random(width), random(height)));
    for (int i = 0; i < initialPredators; i++) predatorList.add(new Predator(random(width), random(height)));
    // Taste s = speichern
  }
  if (key == 's') {
    saveFrame("mack-farbig-####.png");
    println("gespeichert");
  }
}
