/**
 * @file Sobel.pde
 * @brief class to create the sobel image
 *
 * @authors Pere Adell  
 *          Thierry Bossy
 *          Rafael Pizzarro
 * @date 28.04.2016
 */
class Sobel {

  /*
    The Sobel algorithm
  */
  PImage sobel(PImage img) {
    float[][] hKernel = { { 0, 1, 0 }, 
      { 0, 0, 0 }, 
      { 0, -1, 0 } };
    float[][] vKernel = { { 0, 0, 0 }, 
      { 1, 0, -1 }, 
      { 0, 0, 0 } };
    PImage result = createImage(img.width, img.height, ALPHA);
    // clear the image
    for (int i = 0; i < img.width * img.height; i++) {
      result.pixels[i] = color(0);
    }

    float max=0;
    float[] buffer = new float[img.width * img.height];

    img.loadPixels();

    /*
      Implementation of the double convolution
     */
    for (int y = 1; y < img.height - 1; y++) {
      for (int x = 1; x < img.width - 1; x++) {
        int i;
        float sum_h, sum_v;
        
        i = y * img.width + x;
        
        sum_h = conv.pixConvolution(img, hKernel, 1., x, y);
        sum_v = conv.pixConvolution(img, vKernel, 1., x, y);
        buffer[i] = sqrt((sum_h*sum_h) + (sum_v*sum_v));
        max = max(max, buffer[i]);
      }
    }
    for (int y = 1; y < img.height - 1; y++) { // Skip top and bottom edges
      for (int x = 1; x < img.width - 1; x++) { // Skip left and right
        int index = y * img.width + x;
        if (buffer[index] > (int)(max * 0.3f)) { // 30% of the max
          result.pixels[index] = color(255);
        } else {
          result.pixels[index] = color(0);
        }
      }
    }

    result.updatePixels();
    return result;
  }
}