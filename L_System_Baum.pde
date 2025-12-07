import java.util.Stack;

String axiom = "F";
String sentence = axiom;
int iterations = 5;

HashMap<Character, String> rules = new HashMap<Character, String>();
float baseAngle = radians(25);  // Grundwinkel
float baseLen = 100;

void setup() {
  size(800, 600);
  background(210, 30, 95);
  stroke(0, 80, 90);

  rules.put('F', "FF+[+F-F-F]-[-F+F+F]");

  for (int i = 0; i < iterations; i++) {
    sentence = generate(sentence);
  }

  translate(width/2, height);
  drawSentence(sentence, baseLen);
}

String generate(String input) {
  StringBuilder output = new StringBuilder();
  for (int i = 0; i < input.length(); i++) {
    char c = input.charAt(i);
    if (rules.containsKey(c)) {
      output.append(rules.get(c));
    } else {
      output.append(c);
    }
  }
  return output.toString();
}

void drawSentence(String s, float len) {
  Stack<PVector> posStack = new Stack<PVector>();
  Stack<Float> angleStack = new Stack<Float>();
  PVector currentPos = new PVector(0,0);
  float currentAngle = -PI/2; // nach oben

  for (int i = 0; i < s.length(); i++) {
    char c = s.charAt(i);

    if (c == 'F') {
      // leichte Längenvariation
      float randLen = len * random(0.85, 1.15);
      PVector newPos = new PVector(
        currentPos.x + randLen * cos(currentAngle),
        currentPos.y + randLen * sin(currentAngle)
      );

      // leichte Farbvariation je nach Höhe
      float hueVal = map(newPos.y, 0, height, 100, 50) + random(-10,10);
      stroke(hueVal, 80, 90);
      strokeWeight(map(randLen, len*0.85, len*1.15, 3, 8));

      line(currentPos.x, currentPos.y, newPos.x, newPos.y);
      currentPos = newPos;

    } else if (c == '+') {
      currentAngle += baseAngle + radians(random(-10,10)); // Winkelvariation
    } else if (c == '-') {
      currentAngle -= baseAngle + radians(random(-10,10));
    } else if (c == '[') {
      posStack.push(currentPos.copy());
      angleStack.push(currentAngle);
    } else if (c == ']') {
      currentPos = posStack.pop();
      currentAngle = angleStack.pop();
    }
  }
}
