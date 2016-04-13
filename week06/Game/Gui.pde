class Gui {
  // Gui values
  private final static int margin = 10;
  // background
  private PGraphics background;
  private final static int backgroundHeight = 150;
  private final static int backgroundWidth = WINDOW_WIDTH;
  private final static int backgroundPosX = 0;
  private final static int backgroundPosY = WINDOW_HEIGHT - backgroundHeight;
  // TopView
  private PGraphics topView;
  private final static int topViewSide = backgroundHeight - 2*margin;
  private final static int topViewPosX = 10;
  private final static int topViewPosY = backgroundPosY + margin;
  // Score Board
  private PGraphics score; 
  
  
  private void drawBackground() {
    background.beginDraw();
    background.background(225, 225, 175);
    background.endDraw();
  }
  
  private void drawTopView() {
    topView.beginDraw();
    topView.background(255);
    topView.endDraw();
  }
  
  public void drawGui() {
    drawBackground();
    image(background, backgroundPosX, backgroundPosY);
    drawTopView();
    image(topView, topViewPosX, topViewPosY);
  }
  
  public void setupGui(){
    background = createGraphics(backgroundWidth, backgroundHeight,P2D);
    topView = createGraphics(topViewSide,topViewSide,P2D);
  }
}