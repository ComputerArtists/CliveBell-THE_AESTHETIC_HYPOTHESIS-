// ------------------------------------------------------
// CYBERPUNK CITY – FULL EDITION
// ------------------------------------------------------

ArrayList<RainDrop> rain = new ArrayList<RainDrop>();
ArrayList<Panel> panels = new ArrayList<Panel>();

void setup() {
  size(1100, 700, P3D);
  smooth(8);

  // Regen vorbereiten
  for (int i = 0; i < 450; i++) rain.add(new RainDrop());

  // Leuchtende Werbepanels
  for (int i = 0; i < 8; i++) panels.add(new Panel());
}

void draw() {
  background(5);

  // leichtes Kamerawobbeln (dreckiger Cyberpunk-Look)
  float wobX = sin(frameCount * 0.009) * 30;
  float wobY = cos(frameCount * 0.008) * 20;

  camera(width/2 + wobX, height/3 + wobY, 650,
         width/2, height/2 + 50, 0,
         0, 1, 0);

  lights();
  colorMode(HSB, 360, 100, 100);

  drawCityLayers();
  drawPanels();
  drawRain();
  drawFog();
  drawNoise();
}

// ------------------------------------------------------
// CITY BUILDINGS (simple silhouettes + noise)
// ------------------------------------------------------
void drawCityLayers() {
  pushMatrix();
  translate(width/2, height/2 + 200, -800);

  noStroke();

  for (int i = 0; i < 10; i++) {
    pushMatrix();
    float offset = i * 120;

    translate(0, 0, -offset);

    fill(230, 20, 60 - i * 5); // dark, polluted city layers

    rectMode(CENTER);
    rect(0, 0, 1600 - i * 80, 800 - i * 40);

    // neon window noise
    for (int w = -700; w < 700; w += 25) {
      if (random(1) < 0.1) {
        float h = map(i, 0, 10, 80, 120);
        fill(h, 100, 100, 80);
        rect(w, random(-300, 300), 10, 10);
      }
    }

    popMatrix();
  }

  popMatrix();
}

// ------------------------------------------------------
// NEON AD PANELS – floating, flickering
// ------------------------------------------------------
class Panel {
  float x, y, z;
  float flicker;

  Panel() {
    x = random(width/2 - 500, width/2 + 500);
    y = random(height/2 - 200, height/2 + 100);
    z = random(-200, -1400);
    flicker = random(100);
  }

  void drawPanel() {
    pushMatrix();
    translate(x, y, z);

    flicker += random(0.3);
    float br = 60 + sin(flicker * 0.3) * 40;

    fill(300, 100, br, 90); // pink-magenta
    noStroke();
    rectMode(CENTER);

    rect(0, 0, 180, 80);

    // fake hologram text
    textAlign(CENTER, CENTER);
    textSize(20);
    fill(50, 0, 100);
    text("未来 / CYBER", 0, 0);

    popMatrix();
  }
}

void drawPanels() {
  for (Panel p : panels) p.drawPanel();
}

// ------------------------------------------------------
// NEON RAIN – vertical light drops
// ------------------------------------------------------
class RainDrop {
  PVector pos;
  float speed;
  float length;

  RainDrop() {
    pos = new PVector(random(width), random(height), random(-800, 200));
    speed = random(6, 18);
    length = random(8, 20);
  }

  void update() {
    pos.y += speed;
    if (pos.y > height + 50) {
      pos.y = -50;
      pos.x = random(width);
      pos.z = random(-800, 200);
    }
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);

    strokeWeight(2);
    stroke(200, 100, 100, 90); // neon blue-white
    line(0, 0, 0, -length);

    popMatrix();
  }
}

void drawRain() {
  for (RainDrop r : rain) {
    r.update();
    r.show();
  }
}

// ------------------------------------------------------
// FOG – cyberpunk dirty haze
// ------------------------------------------------------
void drawFog() {
  noStroke();
  fill(280, 40, 40, 50);

  for (int i = 0; i < 5; i++) {
    rect(0, i * 140, width, 140);
  }
}

// ------------------------------------------------------
// NOISE – screen dirt, static, dystopian flicker
// ------------------------------------------------------
void drawNoise() {
  loadPixels();
  for (int i = 0; i < pixels.length; i += 30) {
    if (random(1) < 0.005) {
      pixels[i] = color(0, 0, 100);
    }
  }
  updatePixels();
}

// Taste s = speichern
void keyPressed() {
  if (key == 's') {
    saveFrame("mack-farbig-####.png");
    println("gespeichert");
  }
}
