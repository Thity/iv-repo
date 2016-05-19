/**
 * @file Convolution.pde
 * @brief All functions for convolute
 *
 * @authors Pere Adell  
 *          Thierry Bossy
 *          Rafael Pizzarro
 * @date 05.05.2016
 */

class Convolution {

  PImage convolution(PImage img, float[][] kernel, float weight) {
    int n = kernel.length; /*
                             by assumption of the Kernel being a square matrix.
     */
    float maximum = 0;
    float minimum = 10000000;
    img.loadPixels();
    PImage res = createImage(img.width, img.height, ALPHA);
    for (int i = 0; i < img.width; ++i) {
      for (int j = 0; j < img.height; ++j) {
        // border
        int index = j*img.width + i;
        if (i < n/2 || i >= img.width-n/2 || j < n/2 || j >= img.height-n/2) {
          res.pixels[index] = color(brightness(img.pixels[index]));
        } else {
          float c = pixConvolution(img, kernel, weight, i, j);
          res.pixels[index] = color(c);
          maximum = max(maximum, c);
          minimum = min(minimum, c);
        }
      }
    }
          res.updatePixels();
      return res;
  }

  /*
    Convolution of a pixel
   */
  float pixConvolution(PImage img, float[][] kernel, float weight, int x, int y) {
    int n;
    float pixel;
    n = kernel.length; /*
                        by assumption of the Kernel being a square matrix.
     */
    pixel = 0;
    for (int i = -n/2; i <= n/2; ++i) {
      for (int j = -n/2; j <= n/2; ++j) {
        pixel += brightness(img.pixels[(x+i) + (y+j)*img.width]) * kernel[n/2+j][n/2+i];
      }
    }
    return pixel/weight;
  }

  PImage gaussianBlur(PImage img) {
    float[][] kernel = {
      {9, 12, 9}, 
      {12, 15, 12}, 
      {9, 12, 9}
    };

    return convolution(img, kernel, 99);
  }

  //The Sobel algorithm
  PImage sobel(PImage img) {
    float[][] hKernel = { 
      { 0, 1, 0 }, 
      { 0, 0, 0 }, 
      { 0, -1, 0 } };
    float[][] vKernel = { 
      { 0, 0, 0 }, 
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
    float sum_h, sum_v;
    int i;

    //Implementation of the double convolution
    for (int y = 1; y < img.height - 1; y++) {
      for (int x = 1; x < img.width - 1; x++) {

        i = y * img.width + x;
        sum_h = pixConvolution(img, hKernel, 1., x, y);
        sum_v = pixConvolution(img, vKernel, 1., x, y);
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