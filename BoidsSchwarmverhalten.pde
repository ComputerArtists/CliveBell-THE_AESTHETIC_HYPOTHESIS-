// Boids / Schwarmverhalten mit Maus-Interaktion und Slider-Steuerung

ArrayList<Boid> boids;
int numBoids = 150;

// Slider-Werte
float maxSpeedSlider = 2.0;
float maxForceSlider = 0.05;

// Mausinteraktion
boolean attract = true; // true = anziehen, false = abstoßen

void setup() {
  size(1000, 700);
  colorMode(HSB, 360, 100, 100);
  boids = new ArrayList<Boid>();

  for (int i = 0; i < numBoids; i++) {
    boids.add(new Boid(random(width), random(height)));
  }
}

void draw() {
  background(210, 30, 95);

  for (Boid b : boids) {
    b.flock(boids);
    b.update();
    b.edges();
    b.interactWithMouse();
    b.show();
  }

  // Slider-Anzeige
  fill(0,0,100);
  textSize(16);
  text("MaxSpeed: " + nf(maxSpeedSlider,1,2) + " (Q/W)", 10, 20);
  text("MaxForce: " + nf(maxForceSlider,1,3) + " (A/S)", 10, 40);
  text("Maus: " + (attract ? "Anziehen" : "Abstoßen") + " (Space)", 10, 60);
}

// --- Boid-Klasse ---
class Boid {
  PVector pos;
  PVector vel;
  PVector acc;
  float maxForce = maxForceSlider;
  float maxSpeed = maxSpeedSlider;

  Boid(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.random2D();
    vel.setMag(random(1,2));
    acc = new PVector();
  }

  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);
    PVector ali = align(boids);
    PVector coh = cohesion(boids);

    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);

    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  void update() {
    vel.add(acc);
    vel.limit(maxSpeedSlider);
    pos.add(vel);
    acc.mult(0);
  }

  void edges() {
    if (pos.x > width) pos.x = 0;
    if (pos.x < 0) pos.x = width;
    if (pos.y > height) pos.y = 0;
    if (pos.y < 0) pos.y = height;
  }

  void show() {
    float hue = map(vel.mag(), 0, maxSpeedSlider, 180, 300);
    fill(hue, 80, 90);
    noStroke();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading());
    beginShape();
    vertex(0, -4);
    vertex(-3, 4);
    vertex(3, 4);
    endShape(CLOSE);
    popMatrix();
  }

  // --- Separation
  PVector separate(ArrayList<Boid> boids) {
    float desiredSeparation = 25;
    PVector steer = new PVector();
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(pos, other.pos);
      if ((d > 0) && (d < desiredSeparation)) {
        PVector diff = PVector.sub(pos, other.pos);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) steer.div((float)count);
    if (steer.mag() > 0) {
      steer.setMag(maxSpeedSlider);
      steer.sub(vel);
      steer.limit(maxForceSlider);
    }
    return steer;
  }

  // --- Alignment
  PVector align(ArrayList<Boid> boids) {
    float neighborDist = 50;
    PVector sum = new PVector();
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(pos, other.pos);
      if ((d > 0) && (d < neighborDist)) {
        sum.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.setMag(maxSpeedSlider);
      PVector steer = PVector.sub(sum, vel);
      steer.limit(maxForceSlider);
      return steer;
    } else return new PVector(0,0);
  }

  // --- Cohesion
  PVector cohesion(ArrayList<Boid> boids) {
    float neighborDist = 50;
    PVector sum = new PVector();
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(pos, other.pos);
      if ((d > 0) && (d < neighborDist)) {
        sum.add(other.pos);
        count++;
      }
    }
    if (count > 0) return seek(sum);
    else return new PVector(0,0);
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, pos);
    desired.setMag(maxSpeedSlider);
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForceSlider);
    return steer;
  }

  // --- Mausinteraktion
  void interactWithMouse() {
    PVector mousePos = new PVector(mouseX, mouseY);
    float d = PVector.dist(pos, mousePos);
    if (d < 100) {
      PVector force = PVector.sub(mousePos, pos);
      force.setMag(0.3);
      if (!attract) force.mult(-1);
      applyForce(force);
    }
  }
}

// --- Tastatursteuerung ---
void keyPressed() {
  if (key == 'q' || key == 'Q') maxSpeedSlider += 0.1;
  if (key == 'w' || key == 'W') maxSpeedSlider -= 0.1;
  if (key == 'a' || key == 'A') maxForceSlider += 0.005;
  if (key == 's' || key == 'S') maxForceSlider -= 0.005;
  if (key == ' ') attract = !attract; // anziehen/abstoßen
    if (key == 's') {
    saveFrame("mack-farbig-####.png");
    println("gespeichert");
  }
}
