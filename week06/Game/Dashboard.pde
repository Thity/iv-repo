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
  
  private PVector mouse;
  
  private float totalScore;
  private float velocity;
  private float lastScore;
  
  private PFont font = createFont("Helvetica", 10);
  
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
                     -map(cylinders.get(i).y , 0, boxSide, 0, TopV_Side) + TopV_Side / 2,
                     map(cylinderRadius, 0, boxSide, 0, TopV_Side) * 2,
                     map(cylinderRadius, 0, boxSide, 0, TopV_Side) * 2); 
   }
   topView.endDraw();
   image(topView, TopV_PosX, TopV_PosY);

  }
  
  private void drawTextView() {
   textView.beginDraw();
   textView.noStroke();
   textView.background(255);
   textView.fill(230, 226, 175);
   textView.rect(3, 3, TextV_Side - 6, TextV_Side - 6);
   textView.fill(0);
   textView.textFont(font);
   //mouse = new PVector (mouseX-boxCenterX, mouseY-boxCenterY);
   textView.text("Total Score:\n" + totalScore + "\n\nVelocity:\n" + velocity + "\n\nLast Score:\n" + lastScore, 30, 30);
   //textView.text("Position Mouse X:" + mouse.x + "\nPosition Mouse Y:\n" + mouse.y + "\n\nBall X:\n" + ball.getLocation().x + "\nBall Y : " + ball.getLocation().y, 30, 30);

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
  
  public Dashboard(){
    background = createGraphics(BG_WIDTH, BG_HEIGHT,P2D);
    topView = createGraphics(TopV_Side, TopV_Side,P2D);
    textView = createGraphics(TextV_Side, TopV_Side, P2D);
    positionView = createGraphics(positionView_Side, positionView_Side);
    totalScore=0;
    velocity=0;
    lastScore=0;
  }
}