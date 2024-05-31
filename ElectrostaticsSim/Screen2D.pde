import controlP5.*;

public class Screen2D extends PApplet{
  private PApplet parent;
  private ControlP5 ui;
   
  /* preferabbly all scalar multiples of each other */
  private int iRes;
  private int jRes;
  private int kRes;
  private int screenRes;
  
  private Cell[][] buffer;
 
  private char renderMode;
  
 /*
  .addItem("Field Vectors", 'v')
                .addItem("Field Lines", 'l')
                .addItem("Potential", 'p')
                .addItem("Charge", 'c')
                .addItem("Equipotential Lines", 'e');
  */
  
  /* constructors */
  public Screen2D(PApplet initParent, int initIRes, int initJRes, int initKRes) {
    super();
    parent = initParent;
    iRes = initIRes;
    jRes = initJRes;
    kRes= initKRes;
    screenRes = max(max(iRes, jRes), jRes);
    renderMode = 'v';
    buffer = new Cell[screenRes][screenRes];
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  
  public void settings() {
    size(500, 500, P2D);
  }
  
  public void setup() {
    surface.setTitle("Render Output");
    surface.setAlwaysOnTop(true);
    ui = new ControlP5(this); 
  }
  
  public void draw() {
    switch (renderMode) {
      case 'v':
        break;
      case 'l':
        break;
      case 'p':
        break;
      case 'c':
        break;
      case 'e':
        break;
      default:
        break;
    }
  }
  
  public void drawVectors() {
  }
  
  public void drawFieldLines() {
  }
  
  public void drawPotential() {
  }
  
  public void drawCharge() {
  }
  
  public void drawEquipotential() {
  }
  
  public void setNewRes(int newIRes, int newJRes, int newKRes) {
    iRes = newIRes;
    jRes = newJRes;
    kRes= newKRes;
  }
  
  public void setMode(char newMode) {
    renderMode = newMode;
  }
  
  public void updateBuffer(Cell[][] newBuffer) {
    buffer = newBuffer;
  }
  
  
}
