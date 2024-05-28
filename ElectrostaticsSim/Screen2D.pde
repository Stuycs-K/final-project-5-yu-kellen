
public class Screen2D extends PApplet{
  private PApplet parent;
  private ControlP5 ui;
  
  private Slicer slicer;
  
  /* constructors */
  public Screen2D(PApplet initParent, Slicer initSlicer) {
    super();
    parent = initParent;
    slicer = initSlicer;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  
  public void settings() {
    size(500, 500, P2D);
  }
  
  public void setup() {
    ui = new ControlP5(this);
    
  }
  
  public void hide() {
    
  }
  
  
}
