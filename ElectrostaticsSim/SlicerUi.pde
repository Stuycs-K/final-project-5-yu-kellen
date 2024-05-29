import controlP5.*;

public class SlicerUi extends PApplet{
  private PApplet parent;
  private Slicer slicer;
  private Screen2D screen;
  private HashMap<String, PFont> fontMap;
  
  private ControlP5 ui;
  
  private RadioButton sliceModeSel;
  private char sliceMode;

  private CheckBox renderModeSel;
  private char renderMode;
  
  private Slider indexSlider;
  private int sliceIndex;
  
  private Slider brightnessSlider;
  private float brightness;
  
  private Slider densitySlider;
  private float density;
  
  
  /* constructors */
  public SlicerUi(
    PApplet initParent, 
    HashMap<String, PFont> initFontMap, 
    Slicer initSlicer, 
    Screen2D initScreen
    ) 
  {
    super();
    parent = initParent;
    fontMap = initFontMap;
    slicer = initSlicer;
    screen = initScreen;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  
  public void settings() {
    size(300, 500, P2D);
  }
  
  public void setup() {

    surface.setTitle("Render Settings");
    surface.setAlwaysOnTop(true);
    ui = new ControlP5(this);
    
    sliceModeSel = ui.addRadioButton("sliceMode")
                .setPosition(50, 25)
                .setItemWidth(20)
                .setItemHeight(20)
                .addItem("XY", 'z')
                .addItem("XZ", 'y')
                .addItem("YZ", 'x');
                
    /* edit fonts */
    for (Toggle t : sliceModeSel.getItems()) {
      t.getCaptionLabel().setFont(fontMap.get("p"));
    }
    
    indexSlider = ui.addSlider("sliceIndex")
                    .setPosition(50, 100)
                    .setSize(150, 20)
                    .setRange(0, 255)
                    .setFont(fontMap.get("p"));
                    
                    
     renderModeSel = ui.addCheckBox("renderMode")
                .setPosition(50, 150)
                .setItemWidth(20)
                .setItemHeight(20)
                .addItem("Field Vectors", 'v')
                .addItem("Field Lines", 'l')
                .addItem("Potential", 'p')
                .addItem("Charge", 'c')
                .addItem("Equipotential Lines", 'e')
                .addItem("Gridlines", 'g');
                
     for (Toggle t : renderModeSel.getItems()) {
      t.getCaptionLabel().setFont(fontMap.get("p"));
    }
    
    brightnessSlider = ui.addSlider("brightness")
                         .setPosition(50, 300)
                         .setSize(150, 20)
                         .setRange(0, 255)
                         .setFont(fontMap.get("p"));
                         
    densitySlider = ui.addSlider("density")
                         .setPosition(50, 340)
                         .setSize(150, 20)
                         .setRange(0, 1)
                         .setFont(fontMap.get("p"));
                
                    
    
    
    
    
}
  
  public void draw() {    
    background(0);
    
  }
  
  public void controlEvent(ControlEvent event) {
    System.out.println(event);
  }
 
  
  
}
