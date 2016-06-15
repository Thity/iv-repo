import java.text.DecimalFormat;
import java.util.Timer;
class Dashboard {
  // Gui values
  private final static int margin = 10;
  // background
  private final PGraphics background;
  private final static int BG_HEIGHT = 180;
  private final static int BG_WIDTH = WINDOW_WIDTH;
  private final static int BG_PosX = 0;
  private final static int BG_PosY = WINDOW_HEIGHT - BG_HEIGHT;
  // TopView
  private final  PGraphics topView;
  private final static int TopV_Side = BG_HEIGHT - 2*margin;
  private final static int TopV_PosX = margin;
  private final static int TopV_PosY = BG_PosY + margin;
  // Score Board
  private final PGraphics textView; 
  private final static int TextV_Side = BG_HEIGHT - 2*margin;
  private final static int TextV_PosX = TopV_PosX + TopV_Side + margin;
  private final static int TextV_PosY = BG_PosY + margin;
  // Position Board
  private final PGraphics positionView; 
  private final static int positionView_Side = BG_HEIGHT - 2*margin;
  private final static int positionView_PosX = TextV_PosX + TextV_Side + margin;
  private final static int positionView_PosY = BG_PosY + margin;

  // Score
  private final float minNewScore = 0.2;
  private float scoreLastTimeInterval = 0;
  private float lastScore = 0;
  private float totalScore= 0;
  ArrayList<Float> scores = new ArrayList<Float>();
  private final color red = color(255, 0, 0); // Color for negative scores
  private final color green = color(0, 255, 0); // Color for positive scores
  // Bar Chart
  private final color barChartColor = color(230, 230, 200);
  private final PGraphics barChart;
  private final static float chartLength = WINDOW_WIDTH/2 - 4*margin;
  private final static int heightBegin = WINDOW_HEIGHT/4 - 6*margin;
  private final static int recHeight = 5;

  // Scroll Board
  private final int scrollBarLength = WINDOW_WIDTH - 2*TopV_Side - 4*margin; // For scroll length
  private final int scrollBarPosX = TextV_PosX + TextV_Side + margin;
  private final int scrollBarPosY = BG_PosY + TextV_Side - margin;
  private final HScrollbar hs;

  // Timer
  Timer timer;
  private int lastTimeInterval = 0;
  private final int timeInterval = 1000;

  private PVector mouse;

  private float velocity;
  DecimalFormat numberFormat = numberFormat = new DecimalFormat ("0.000");
  private final static int textSize = 10;
  private PFont font = createFont("Helvetica", textSize);



  private void drawBackground() {
    background.beginDraw();
    background.fill(230, 226, 175);
    background.noStroke();
    background.rect(0, 0, BG_WIDTH, BG_HEIGHT);
    background.endDraw();
    image(background, BG_PosX, BG_PosY);
  }

  private void drawTopView(ArrayList<PVector> cylinders, float cylinderRadius, 
    float ballRadius, PVector ball, float boxSide) {
    topView.beginDraw();
    topView.background(6, 100, 130);
    topView.noStroke();
    topView.fill(255, 0, 0);
    topView.ellipse(map(ball.x, 0, boxSide, 0, TopV_Side) + TopV_Side / 2, 
      -map(ball.y, 0, boxSide, 0, TopV_Side) + TopV_Side / 2, 
      map(ballRadius, 0, boxSide, 0, TopV_Side) * 2, 
      map(ballRadius, 0, boxSide, 0, TopV_Side) * 2);
    topView.fill(230, 226, 175);
    for (int i = 0; i < cylinders.size(); i++) {
      topView.ellipse(map(cylinders.get(i).x, 0, boxSide, 0, TopV_Side) + TopV_Side / 2, 
        -map(cylinders.get(i).y, 0, boxSide, 0, TopV_Side) + TopV_Side / 2, 
        map(cylinderRadius, 0, boxSide, 0, TopV_Side) * 2, 
        map(cylinderRadius, 0, boxSide, 0, TopV_Side) * 2);
    }
    topView.endDraw();
    image(topView, TopV_PosX, TopV_PosY);
  }

  private void drawTextView() {
    hs.update();
    textView.beginDraw();
    textView.noStroke();
    textView.background(255);
    textView.fill(230, 226, 175);
    textView.rect(3, 3, TextV_Side - 6, TextV_Side - 6);
    textView.fill(0);
    textView.textFont(font);
    textView.text("Total Score:\n" + totalScore + "\n\nVelocity:\n" + velocity + "\n\nLast Score:\n" + lastScore, 30, 30);

    textView.endDraw();
    image(textView, TextV_PosX, TextV_PosY);
  }

  private void drawPositionView() {
    positionView.beginDraw();
    positionView.noStroke();
    positionView.background(255);
    positionView.fill(230, 226, 175);
    positionView.rect(3, 3, positionView_Side - 6, positionView_Side - 6);
    positionView.fill(0);
    positionView.textFont(font);
    positionView.endDraw();
    image(positionView, positionView_PosX, positionView_PosY);
  }

  public void drawGui() {
    drawBackground();
    drawTopView(cylinders, cylinderBaseRadius, radiusBall, ball.location, boxX);
    drawTextView();
    drawPositionView();
  }

  public void setScore(float score) {
    totalScore += score;
    lastScore = score;
  }

  public void setVelocity(float v) {
    velocity = v;
  }

  void drawBarChart() {
    hs.update();
    int nbToShow = 10 + (int)(90 * ((exp(hs.getPos()) - 1) / exp(1)));
    float recLength = chartLength / nbToShow;
    pushStyle();
    barChart.beginDraw();
    barChart.background(barChartColor);
    int beginIndex = max(0, scores.size() - nbToShow);
    for (int i=beginIndex; i < scores.size(); i++) {
      int h = 1 + (int)log(1. + 1000. * abs(scores.get(i))); // Logarithmic scale to show the differences
      if (scores.get(i) >= 0.)
        barChart.fill(green);
      else
        barChart.fill(red);
      for (int j=0; j<h; j++) {
        barChart.rect(margin + ((i - beginIndex) * recLength), heightBegin - (j*recHeight), recLength, -recHeight);
      }
    }


    barChart.endDraw();
    popStyle();
  }

  void updateScroll() {
    pushStyle();
    hs.update();
    hs.display();
    popStyle();
  }
  void pauseScore() {
    timer.pause();
  }

  void runScore() {
    timer.run();
  }
  void updateScoreStatistics(float newScore) {
    if (timer.getElapsed()/timeInterval > lastTimeInterval) {
      scores.add(scoreLastTimeInterval);
      lastTimeInterval++;
      scoreLastTimeInterval = 0.;
    }
    if (abs(newScore) > minNewScore) {
      lastScore = newScore;
      totalScore += lastScore;
      scoreLastTimeInterval += newScore;
    }
  }

  void drawAll() {

    dashboard.drawBackground();
    dashboard.drawTopView(cylinders, cylinderBaseRadius, radiusBall, ball.location, boxX);
    dashboard.drawTextView();
    dashboard.updateScroll();

    drawBarChart();
  }

  public Dashboard() {

    timer = new Timer();
    hs = new HScrollbar(scrollBarPosX, scrollBarPosY, scrollBarLength, 20);

    background = createGraphics(BG_WIDTH, BG_HEIGHT, P2D);
    topView = createGraphics(TopV_Side, TopV_Side, P2D);
    textView = createGraphics(TextV_Side, TopV_Side, P2D);
    positionView = createGraphics(positionView_Side, positionView_Side);
    barChart = createGraphics(WINDOW_WIDTH/2 - 2*margin, WINDOW_HEIGHT/4 - 2*margin, P2D);
    totalScore=0;
    velocity=0;
    lastScore=0;
  }
}