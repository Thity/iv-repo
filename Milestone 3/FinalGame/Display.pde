/**
 * @file Display.pde
 * @brief Main class to display result
 *
 * @authors Pere Adell  
 *          Thierry Bossy
 *          Rafael Pizzarro
 * @date 06.05.2016
 */


void draw() {

  img = filter.HSBFilter(img, minHue, maxHue, minSat, maxSat, minBri, maxBri);
  img = conv.gaussianBlur(img);
  img = conv.gaussianBlur(img);
  img = filter.transformToBW(img, 150, 255);
  img = conv.gaussianBlur(img);
  img = conv.gaussianBlur(img);
  img = conv.sobel(img);
  hough.hough(img);
  List<PVector> lines = hough.getBestLines();
  qg.build(lines, img.width, img.height);
  List<int[]> quads = qg.findCycles();

/* Drawing Quads */
  for (int[] quad : quads) {
    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);
    // (intersection() is a simplified version of the
    // intersections() method you wrote last week, that simply
    // return the coordinates of the intersection between 2 lines)
    PVector c12 = qg.intersection(l1, l2);
    PVector c23 = qg.intersection(l2, l3);
    PVector c34 = qg.intersection(l3, l4);
    PVector c41 = qg.intersection(l4, l1);
    // Choose a random, semi-transparent colour
    Random random = new Random();
    if (qg.isConvex(c12, c23, c34, c41) && qg.validArea(c12, c23, c34, c41, 10000000, 0) && qg.nonFlatQuad(c12, c23, c34, c41)) {
      fill(color(min(255, random.nextInt(300)), 
        min(255, random.nextInt(300)), 
        min(255, random.nextInt(300)), 50));
      quad(c12.x, c12.y, c23.x, c23.y, c34.x, c34.y, c41.x, c41.y);
    }
  }

  noLoop();
}