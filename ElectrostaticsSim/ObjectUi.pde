import controlP5.*;

public class ObjectUi extends PApplet{
  private PApplet parent;
  private ControlP5 ui;
  
  
  /* constructors */
  public ObjectUi(PApplet initParent) {
    super();
    parent = initParent;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  
  public void settings() {
    size(500, 500, P2D);
  }
  
  public void setup() {
    surface.setAlwaysOnTop(true);
    ui = new ControlP5(this);
    
  }
  
  public void hide() {
    
  }
  
  
}
