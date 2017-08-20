PShape s;
PShape sphere;
PImage world;
PShader edge;
PShader blur;
float a = 0;

void setup() {
  size(400,400,P3D);
  frameRate(25);
  PGraphics g = createGraphics(700, 349);
  g.beginDraw();
  PImage tmp = loadImage("world.png");
  tmp.filter(INVERT);
  g.tint(100, 255, 0);
  g.image(tmp, 0, 0);
  g.endDraw();
  world = createGraphics(700, 349);
  world = g.get(0, 0, 700, 349);
  sphere = makeSphere(150, 5, world);
  edge = loadShader("edge.glsl");
  blur = loadShader("blur.glsl");
}

void draw() {
  background(0);
  translate(width / 2, height / 2);
  lights();
  pushMatrix();
  shape(sphere);
  rotateX(radians(-30));
  rotateY(a);
  a += 0.01;
  shape(sphere);
  popMatrix();
  filter(edge);
  filter(blur);
}

PShape makeSphere(int r, int step, PImage img) {
  s = createShape();
  s.beginShape(QUAD_STRIP);
  s.texture(img);
  s.fill(200);
  s.stroke(0, 0, 255);
  s.strokeWeight(1);
  for (int i = 0; i < 180; i += step) {
    float sin_i = sin(radians(i));
    float cos_i = cos(radians(i));
    float sin_ip = sin(radians(i + step));
    float cos_ip = cos(radians(i + step));
    for (int j = 0; j <= 360; j += step) {
      float sin_j = sin(radians(j));
      float cos_j = cos(radians(j));
      s.normal(cos_j * sin_i, -cos_i, sin_j * sin_i);
      s.vertex(r * cos_j * sin_i, -r * cos_i, r * sin_j * sin_i, img.width - j * img.width / 360, i * img.height / 180);
      s.normal(cos_j * sin_ip, -cos_ip, sin_j * sin_ip);
      s.vertex(r * cos_j * sin_ip, -r * cos_ip, r * sin_j * sin_ip, img.width - j * img.width / 360, (i + step) * img.height / 180);
    }
  }
  s.endShape();
  return s;
}