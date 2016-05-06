PImage img;

PImage result = createImage(width, height, RGB); // create a new, initially transparent, ’result’ image
for (int i = 0; i < img.width * img.height; i++) {
  // do something with the pixel img.pixels[i]
}

void settings() {
  size(800, 600);
}

void setup() {
  img = loadImage("board1.jpg");
  noLoop(); // no interactive behaviour: draw() will be called only once.
}

void draw() {
  for (int i = 0; i < img.width * img.height; i++) {
    img.pixels[i].brighness();// do something with the pixel img.pixels[i]
  }
  image(result, 0, 0);
}