// ----------------------------------------
// Emotion Particle Cloud
// ----------------------------------------

ArrayList<Particle> particles = new ArrayList<Particle>();
Emotion currentEmotion;

void setup() {
  size(900, 600);
  smooth(8);

  currentEmotion = new Emotion("Neutral", 0.0, 0.2, 0.5);

  for (int i = 0; i < 300; i++) {
    particles.add(new Particle());
  }
}

void draw() {
  // Hintergrund abhängig von Valenz leicht einfärben
  float bgVal = map(currentEmotion.valence, -1, 1, -40, 40);
  background(20 + bgVal);

  for (Particle p : particles) {
    p.update();
    p.display();
  }

  drawUI();
}

// ----------------------------------------
// PARTICLE
// ----------------------------------------
class Particle {
  PVector pos, vel;
  float size;
  float life;

  Particle() {
    pos = new PVector(random(width), random(height));
    vel = new PVector(random(-1, 1), random(-1, 1));
    size = random(2, 6);
    life = random(0.5, 1.0);
  }

  void update() {
    float a = currentEmotion.arousal;
    float v = currentEmotion.valence;

    // Perlin Noise Drift
    float n = noise(pos.x * 0.005, pos.y * 0.005, frameCount * 0.01);
    float angle = map(n, 0, 1, -PI, PI);
    vel.add(PVector.fromAngle(angle).mult(map(a, 0, 1, 0.1, 0.6)));

    // Emotion-influenced damping
    vel.mult(0.96 - a * 0.2);

    pos.add(vel);

    // Wrap around
    if (pos.x < 0) pos.x = width;
    if (pos.x > width) pos.x = 0;
    if (pos.y < 0) pos.y = height;
    if (pos.y > height) pos.y = 0;
  }

  void display() {
    noStroke();

    // Farbe aus Valenz
    float h = map(currentEmotion.valence, -1, 1, 200, 20);
    float s = map(currentEmotion.intensity, 0, 1, 40, 100);
    float b = map(currentEmotion.arousal, 0, 1, 100, 200);

    colorMode(HSB, 360, 100, 100);
    fill(h, s, b, 90);

    // Form abhängig von Emotion
    if (currentEmotion.valence < 0) {
      // negative → kantig
      pushMatrix();
      translate(pos.x, pos.y);
      float rot = frameCount * 0.02 * currentEmotion.arousal;
      rotate(rot);
      rectMode(CENTER);
      rect(0, 0, size*1.6, size*1.6);
      popMatrix();
    } else {
      // positive → weich
      ellipse(pos.x, pos.y, size*2.0, size*2.0);
    }
  }
}

// ----------------------------------------
// EMOTION
// ----------------------------------------
class Emotion {
  String name;
  float valence;   // -1 ... +1
  float arousal;   // 0 ... 1
  float intensity; // 0 ... 1

  Emotion(String n, float v, float a, float i) {
    name = n;
    valence = v;
    arousal = a;
    intensity = i;
  }
}

// ----------------------------------------
// UI + Steuerung
// ----------------------------------------
void keyPressed() {
  if (key == '1') currentEmotion = new Emotion("Freude", 0.8, 0.6, 0.8);
  if (key == '2') currentEmotion = new Emotion("Traurigkeit", -0.6, 0.2, 0.6);
  if (key == '3') currentEmotion = new Emotion("Wut", -0.7, 0.9, 1.0);
  if (key == '4') currentEmotion = new Emotion("Neugier", 0.2, 0.7, 0.5);
  if (key == 's') { saveFrame("mack-farbig-####.png"); println("gespeichert");
  }
}

void mouseDragged() {
  // Mausbewegung steuert Emotion direkt
  float v = map(mouseX, 0, width, -1, 1);
  float a = map(mouseY, height, 0, 0, 1);
  currentEmotion.valence = constrain(v, -1, 1);
  currentEmotion.arousal = constrain(a, 0, 1);
}

void drawUI() {
  fill(255, 150);
  textSize(14);
  text("Emotion: " + currentEmotion.name, 20, 30);
  text("Valenz: " + nf(currentEmotion.valence, 1, 2), 20, 50);
  text("Arousal: " + nf(currentEmotion.arousal, 1, 2), 20, 70);
  text("1 Freude | 2 Traurigkeit | 3 Wut | 4 Neugier | Maus = manuell", 20, height - 20);
}
