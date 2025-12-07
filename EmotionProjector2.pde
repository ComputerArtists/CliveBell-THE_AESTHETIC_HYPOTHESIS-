// ------------------------------------------------------
// Herz / Spiegel der Stimmung – FULL EDITION
// ------------------------------------------------------

Emotion emotion;
ArrayList<Mirror> mirrors = new ArrayList<Mirror>();

void setup() {
  size(900, 700, P2D);
  smooth(8);

  emotion = new Emotion("Neutral", 0.0, 0.2, 0.3);

  // Spiegel rund um das Herz
  for (int i = 0; i < 8; i++) {
    mirrors.add(new Mirror(i));
  }
}

void draw() {
  background(15);

  drawHeart();
  drawMirrors();
  drawUI();
}

// ------------------------------------------------------
// EMOTION-KLASSE
// ------------------------------------------------------
class Emotion {
  float valence;   // -1 = negativ, +1 = positiv
  float arousal;   // 0 = ruhig, 1 = hoch
  float intensity; // für Glühen, Puls

  String name;

  Emotion(String n, float v, float a, float i) {
    name = n;
    valence = v;
    arousal = a;
    intensity = i;
  }
}

// ------------------------------------------------------
// DAS ZENTRALE HERZ
// ------------------------------------------------------
void drawHeart() {

  pushMatrix();
  translate(width/2, height/2);

  float pulse = 1 + sin(frameCount * (0.05 + emotion.arousal * 0.2)) * (0.1 + emotion.intensity * 0.2);

  float softness = map(emotion.valence, -1, 1, 0.0, 1.0); // negativ = hart, positiv = weich

  // Herz-Farbe
  colorMode(HSB, 360, 100, 100);
  float hue = map(emotion.valence, -1, 1, 220, 0); // blau → rot
  float bright = map(emotion.intensity, 0, 1, 40, 100);
  fill(hue, 90, bright, 100);

  noStroke();
  scale(200 * pulse);

  beginShape();
  for (float a = 0; a < TWO_PI; a += 0.02) {
    float r;

    if (emotion.valence < 0) {
      // kantiges Herz (zerbrochen)
      r = 0.7 + sin(a * 3) * 0.1 * (1 - softness);
    } else {
      // weiches Herz
      r = 0.7 + sin(a * 2) * 0.05 * softness;
    }

    // Herzform-Formel
    float x = 16 * pow(sin(a), 3) * r;
    float y = -(13 * cos(a) - 5 * cos(2*a) - 2 * cos(3*a) - cos(4*a)) * r * 0.7;

    vertex(x / 20, y / 20);
  }
  endShape(CLOSE);

  popMatrix();
}

// ------------------------------------------------------
// SPIEGEL / NEBENSCHRIFTEN UM DAS HERZ
// ------------------------------------------------------
class Mirror {
  float angle;
  float dist;

  Mirror(int i) {
    angle = TWO_PI / 8 * i;
    dist = 250;
  }

  void drawMirror() {
    pushMatrix();

    float moodDistort = map(emotion.valence, -1, 1, 0.8, 1.3);
    float wobble = sin(frameCount * 0.02 + angle) * emotion.arousal * 20;

    float mx = width/2 + cos(angle) * dist + wobble;
    float my = height/2 + sin(angle) * dist + wobble;

    translate(mx, my);

    float s = 0.5 + emotion.intensity * 0.5;

    scale(s);

    noFill();
    strokeWeight(2);
    stroke(200, 20, 100, 80);

    // Spiegelkreis (leicht deformiert)
    beginShape();
    for (float a = 0; a < TWO_PI; a += 0.1) {
      float r = 60 + sin(a * 3 + frameCount * 0.01) * 10 * (1 - emotion.valence);
      vertex(cos(a) * r, sin(a) * r);
    }
    endShape(CLOSE);

    // Reflexion des Herzens
    drawHeartReflection();

    popMatrix();
  }

  void drawHeartReflection() {
    pushMatrix();

    float refScale = 0.15 + 0.1 * emotion.intensity;
    scale(refScale);

    float pulse = 1 + sin(frameCount * (0.05 + emotion.arousal * 0.1)) * 0.05;

    scale(pulse);

    // Reflexionsfarbe (blasser)
    float hue = map(emotion.valence, -1, 1, 220, 0);
    fill(hue, 60, 90, 60);
    noStroke();

    beginShape();
    for (float a = 0; a < TWO_PI; a += 0.05) {
      float x = 16 * pow(sin(a), 3);
      float y = -(13 * cos(a) - 5 * cos(2*a) - 2 * cos(3*a) - cos(4*a));
      vertex(x, y);
    }
    endShape(CLOSE);

    popMatrix();
  }
}

void drawMirrors() {
  for (Mirror m : mirrors) {
    m.drawMirror();
  }
}

// ------------------------------------------------------
// INTERAKTION
// ------------------------------------------------------
void mouseDragged() {
  emotion.valence = map(mouseX, 0, width, -1, 1);
  emotion.arousal = map(mouseY, height, 0, 0, 1);
}

void keyPressed() {
  if (key == '1') emotion = new Emotion("Freude", 0.8, 0.5, 0.8);
  if (key == '2') emotion = new Emotion("Traurigkeit", -0.6, 0.2, 0.4);
  if (key == '3') emotion = new Emotion("Wut", -0.9, 0.8, 1.0);
  if (key == '4') emotion = new Emotion("Liebe", 1.0, 0.4, 1.0);
  if (key == '5') emotion = new Emotion("Angst", -0.8, 0.9, 0.7);
  if (key == 's') { saveFrame("mack-farbig-####.png"); println("gespeichert");}
}

// ------------------------------------------------------
// UI
// ------------------------------------------------------
void drawUI() {
  fill(255, 200);
  textSize(14);
  text("Valenz: " + nf(emotion.valence, 1, 2), 20, 30);
  text("Arousal: " + nf(emotion.arousal, 1, 2), 20, 50);
  text("1 Freude | 2 Traurigkeit | 3 Wut | 4 Liebe | 5 Angst | Maus = manuell", 20, height - 20);
}
