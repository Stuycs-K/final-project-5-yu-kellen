import controlP5.*;

public class Screen2D extends PApplet{
  private PApplet parent;
  private ControlP5 ui;
   
  private int res;
  private Cell[][] buffer;
 
  private char mode;
  
 /*
  .addItem("Field Vectors", 'v')
                .addItem("Field Lines", 'l')
                .addItem("Potential", 'p')
                .addItem("Charge", 'c')
                .addItem("Equipotential Lines", 'e');
  */
  
  /* constructors */
  public Screen2D(PApplet initParent, int initRes) {
    super();
    parent = initParent;
    res = initRes;
    buffer = new Cell[res][res];
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
    switch (mode) {
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
  
  public void setMode(char newMode) {
    mode = newMode;
  }
  
  public void updateBuffer(Cell[][] newBuffer) {
    buffer = newBuffer;
  }
  
  
}
