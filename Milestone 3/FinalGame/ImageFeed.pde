class ImageProcessing extends PApplet {
  void settings() {
  }
  void setup() {
  }
  PImage img2;
  void draw() {
    img2 = cam.get();
    image(img2, 0, 0);
    hough.drawBestLines(img);
    hough.drawIntersections();
  }
}