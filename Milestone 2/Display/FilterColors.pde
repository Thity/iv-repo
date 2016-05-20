/**
 * @file FilterColors.pde
 * @brief All functions for filtering
 *
 * @authors Pere Adell  
 *          Thierry Bossy
 *          Rafael Pizzarro
 * @date 10.05.2016
 */

class FilterColors {
  
  public PImage transformToBW(PImage img, float minBrightness, float maxBrightness) {
    
    PImage image = createImage(img.width, img.height, ALPHA); // New output image
    
    img.loadPixels();
    color pix;
    for (int i = 0; i < img.width * img.height; i++) {
      pix = img.pixels[i]; // Pixel to filter
      image.pixels[i] = (brightness(pix) >= minBrightness && brightness(pix) <= maxBrightness) ?
        color(255): color(0); // Filter depending on max
    }
    image.updatePixels();
    return image;
  }

  public PImage HSBFilter(PImage img, float minHue, float maxHue, float minSaturation,
    float maxSaturation, float minBrightness, float maxBrightness) {
      
    PImage image = createImage(img.width, img.height, ALPHA);
    img.loadPixels();
    color pix;
    for (int i = 0; i < img.width * img.height; i++) {
      pix = img.pixels[i];
      float h = hue(pix);
      float b = brightness(pix);
      float s = saturation(pix);
      boolean isValid = (h >= minHue && h <= maxHue) && (b >= minBrightness && b <= maxBrightness)
      && (s >= minSaturation && s <= maxSaturation);
      image.pixels[i] = (isValid ? color(255) : color(0));
    }
    image.updatePixels();
    return image;
  }
}