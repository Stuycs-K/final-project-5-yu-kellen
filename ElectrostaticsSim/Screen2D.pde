import controlP5.*;

public class Screen2D extends PApplet {
  private PApplet parent;
  private ControlP5 ui;
   
  /* preferabbly all scalar multiples of each other */
  private int iRes;
  private int jRes;
  private int kRes;
  private int screenRes;
  private int scale;
  
  public final color voltageCHigh = color(204, 102, 0);
  public final color voltageCLow = color(0, 102, 153);
  
  float minP; 
  float maxP;
  float minC;
  float maxC;
  
  private Cell[][] buffer;
  private Grid3D grid;
 
  private char renderMode;
  
 /*
  .addItem("Field Vectors", 'v')
                .addItem("Field Lines", 'l')
                .addItem("Potential", 'p')
                .addItem("Charge", 'c')
                .addItem("Equipotential Lines", 'e');
  */
  
  /* constructors */
  public Screen2D(
    PApplet initParent,
    Grid3D initGrid,
    int initIRes, int initJRes, int initKRes, 
    int initScale
    ) 
  {
    super();
    parent = initParent;
    grid = initGrid;
    iRes = initIRes;
    jRes = initJRes;
    kRes= initKRes;
    scale = initScale;
    screenRes = max(max(iRes, jRes), jRes);
    renderMode = 'p';
    buffer = new Cell[screenRes][screenRes];
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  
  public void setup() {
    surface.setTitle("Render Output");
    surface.setAlwaysOnTop(true);
  }
  
  public void settings() {
    size(screenRes*scale, screenRes*scale);
  }
  
  public void draw() {
    float val;
    float ratio;
    color colorVal;
    if (buffer[0][0] != null) {
      for (int i=0; i<buffer.length; i++) {
        for (int j=0; j<buffer[i].length; j++) {  
          switch (renderMode) {
            case 'v':
              break;
            case 'l':
              break;
            case 'p':
              val = (float)buffer[i][j].getPotential().doubleValue();
              ratio = abs(val-minP)/abs(maxP - minP);
              colorVal = lerpColor(voltageCLow, voltageCHigh, ratio);
              fill(colorVal);
              stroke(colorVal);
              rect(i*scale, j*scale, scale, scale);
              break;
            case 'c':
              val = (float)buffer[i][j].getCharge().doubleValue();
              ratio = abs(val)/abs(maxC);
              colorVal = lerpColor(voltageCLow, voltageCHigh, ratio);
              fill(colorVal);
              stroke(colorVal);
              rect(i*scale, j*scale, scale, scale);
              break;
            case 'e':
              break;
            default:
              break;
          }
        }
      }
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
    screenRes = max(max(iRes, jRes), jRes);
    surface.setSize(screenRes*scale, screenRes*scale);
  }
  
  public void setScale(int newScale) {
    scale = newScale;
    surface.setSize(screenRes*scale, screenRes*scale);
  }
  
  public void setMode(char newMode) {
    renderMode = newMode;
  }
  
  public void updateBuffer(Cell[][] newBuffer) {
    buffer = newBuffer;
    
    
    for (int i=0; i<buffer.length; i++) {
      for (int j=0; j<buffer[i].length; j++) {
        System.out.print(String.format("%3.2e, ", buffer[i][j].getPotential().doubleValue()));
      }
      System.out.println();
    }
    
    
    
  }
  
  public void updateMinMaxes() {
    minP = grid.getMinSolvedPotential();
    maxP = grid.getMaxSolvedPotential();
    minC = grid.getMinSolvedCharge();
    maxC = grid.getMaxSolvedCharge();
    System.out.println(String.format("P: %ev, %ev C: %ec, %ec", minP, maxP, minC, maxC));
  }
  
}
