/**
 * @file Hough.pde
 * @brief All functions for hough image
 *
 * @authors Pere Adell  
 *          Thierry Bossy
 *          Rafael Pizzarro
 * @date 01.05.2016
 */
class Hough {
  private ArrayList<Integer> bestCandidates = new ArrayList<Integer>();
  private ArrayList<PVector> bestLines = new ArrayList<PVector>();
  private ArrayList<PVector> intersections = new ArrayList<PVector>();
  private float discretizationStepsPhi = 0.06f;
  private float discretizationStepsR = 2.5f;

  // dimensions of the accumulator
  private int phiDim;
  private int rDim;

  // our accumulator (with a 1 pix margin around)
  private int[] accumulator;

  // pre-compute the sin and cos values
  private float[] tabSin;
  private float[] tabCos;

  // size of the region we search for a local maximum
  private int neighbourhood = 10;

  void hough(PImage edgeImg) {
    phiDim = (int) (Math.PI / discretizationStepsPhi);
    rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);

    tabSin = new float[phiDim];
    tabCos = new float[phiDim];
    //compute tabSin and tabCos
    computeTabs();

    accumulator = new int[(phiDim + 2) * (rDim + 2)];
    // Fill the accumulator: on edge points (ie, white pixels of the edge
    // image), store all possible (r, phi) pairs describing lines going
    // through the point.
    for (int y = 0; y < edgeImg.height; y++) {
      for (int x = 0; x < edgeImg.width; x++) {
        // Are we on an edge?
        if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {

          // ...determine here all the lines (r, phi) passing through
          // pixel (x,y), convert (r,phi) to coordinates in the
          // accumulator, and increment accordingly the accumulator.
          // Be careful: r may be negative, so you may want to center onto
          // the accumulator with something like: r += (rDim - 1) / 2
          for (int phi = 0; phi < phiDim; phi++) {
            float r = (x * tabCos[phi]) + (y * tabSin[phi]);
            r += (rDim - 1) * 0.5;
            accumulator[(phi+1)*(rDim+2)+(int)(r+1)] += 1;
          }
        }
      }
    }
    computeBestCandidates();
    Collections.sort(bestCandidates, new HoughComparator(accumulator));
  }

  private void computeTabs() {
    float ang = 0;
    float inverseR = 1.f / discretizationStepsR;
    for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
      // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
      tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
      tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
    }
  }

  public void drawIntersections() {
    for (PVector point : intersections) {
      fill(255, 128, 0);
      ellipse(point.x, point.y, 10, 10);
    }
  }


  public void getIntersections(List<PVector> lines) {
    ArrayList<PVector> intersections = new ArrayList<PVector>();
    for (int i = 0; i < lines.size() - 1; i++) {
      PVector line1 = lines.get(i);
      for (int j = i + 1; j < lines.size(); j++) {
        PVector line2 = lines.get(j);

        // compute the intersection and add it to ’intersections’
        if (line1.y != line2.y) {//not parallel

          double sin_t1 = Math.sin(line1.y);
          double sin_t2 = Math.sin(line2.y);
          double cos_t1 = Math.cos(line1.y);
          double cos_t2 = Math.cos(line2.y);
          float r1 = line1.x;
          float r2 = line2.x;

          double denom = cos_t2 * sin_t1 - cos_t1 * sin_t2;

          int x = (int) ((r2 * sin_t1 - r1 * sin_t2) / denom);
          int y = (int) ((-r2 * cos_t1 + r1 * cos_t2) / denom);
          intersections.add(new PVector(x, y));
          fill(255, 128, 0);
          ellipse(x, y, 10, 10);
        }
      }
    }
  }

  public PImage houghImg() {
    PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
    for (int i = 0; i < accumulator.length; i++) {
      houghImg.pixels[i] = color(min(255, accumulator[i]));
    }

    // You may want to resize the accumulator to make it easier to see:
    houghImg.resize(400, 400);
    houghImg.updatePixels();

    return houghImg;
  }

  private PVector computePolars(int idx) {
    int accPhi = (int) (idx / (rDim + 2)) - 1;
    int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
    float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
    float phi = accPhi * discretizationStepsPhi;
    return new PVector(r, phi);
  }

  public void plotLineFromPolars(PVector rPhi, PImage edgeImg) {
    int x0 = 0;
    int y0 = (int) (rPhi.x / sin(rPhi.y));
    int x1 = (int) (rPhi.x / cos(rPhi.y));
    int y1 = 0;
    int x2 = edgeImg.width;
    int y2 = (int) (-cos(rPhi.y) / sin(rPhi.y) * x2 + rPhi.x / sin(rPhi.y));
    int y3 = edgeImg.width;
    int x3 = (int) (-(y3 - rPhi.x / sin(rPhi.y)) * (sin(rPhi.y) / cos(rPhi.y)));
    // Finally, plot the lines
    stroke(204, 102, 0);
    if (y0 > 0) {
      if (x1 > 0) line(x0, y0, x1, y1);
      else if (y2 > 0) line(x0, y0, x2, y2);
      else line(x0, y0, x3, y3);
    } else {
      if (x1 > 0) {
        if (y2 > 0) line(x1, y1, x2, y2);
        else line(x1, y1, x3, y3);
      } else line(x2, y2, x3, y3);
    }
  }

  public void createBestLinesPolars() {
    int n = bestCandidates.size();
    bestLines = new ArrayList<PVector>();
    if (n > 4) n = 4;
    for (int i = 0; i < n; i++) {
      bestLines.add(computePolars(bestCandidates.get(i)));
    }
  }

  public void drawBestLines(PImage edgeImg) {
    createBestLinesPolars();
    for (PVector rPhi : bestLines) {
      plotLineFromPolars(rPhi, edgeImg);
    }
  }

  public List<PVector> getBestIntersections() {
    getIntersections(bestLines);
    return intersections;
    /*for (PVector point : intersections) {
     fill(255, 128, 0);
     ellipse(point.x, point.y, 10, 10);
     }
     */
  }

  /* Given functions */

  private void computeBestCandidates() {
    bestCandidates = new ArrayList<Integer>();
    // only search around lines with more that this amount of votes
    // (to be adapted to your image)
    int minVotes = 200;

    for (int accR = 0; accR < rDim; accR++) {
      for (int accPhi = 0; accPhi < phiDim; accPhi++) {
        // compute current index in the accumulator
        int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
        if (accumulator[idx] > minVotes) {
          boolean bestCandidate=true;
          // iterate over the neighbourhood
          for (int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
            // check we are not outside the image
            if ( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
            for (int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
              // check we are not outside the image
              if (accR+dR < 0 || accR+dR >= rDim) continue;
              int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
              if (accumulator[idx] < accumulator[neighbourIdx]) {
                // the current idx is not a local maximum!
                bestCandidate=false;
                break;
              }
            }
            if (!bestCandidate) break;
          }
          if (bestCandidate) {
            // the current idx *is* a local maximum
            bestCandidates.add(idx);
          }
        }
      }
    }
  }


  public void plotLines(PImage edgeImg) {
    //For each pair (r, φ) in the accumulator that received more that 200 votes,
    //plot the corresponding line ontop of the image
    for (int idx = 0; idx < accumulator.length; idx++) {
      if (accumulator[idx] > 200) {
        // first, compute back the (r, phi) polar coordinates:
        PVector rPhi = computePolars(idx);

        //Cartesian equation of a line: y = ax + b
        //in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
        //=> y = 0 : x = r / cos(phi)
        //=> x = 0 : y = r / sin(phi)

        // compute the intersection of this line with the 4 borders of
        // the image
        plotLineFromPolars(rPhi, edgeImg);
      }
    }
  }

  public List<PVector> getBestLines() {
    createBestLinesPolars();
    return bestLines;
  }
}

class HoughComparator implements java.util.Comparator<Integer> {
  int[] accumulator;
  public HoughComparator(int[] accumulator) {
    this.accumulator = accumulator;
  }
  @Override
    public int compare(Integer l1, Integer l2) {
    if (accumulator[l1] > accumulator[l2]
      || (accumulator[l1] == accumulator[l2] && l1 < l2)) return -1;
    return 1;
  }
}