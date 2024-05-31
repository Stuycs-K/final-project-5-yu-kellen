import controlP5.*;

int simulationRes;

Grid3D mainGrid;
Slicer mainSlicer;


/* UI */
ControlP5 mainUi;
Screen2D mainScreen2D;
SlicerUi mainSlicerUi;
ObjectUi mainObjectUi;

/* Default Fonts */
HashMap<String, PFont> fontMap;

/* Fun */
PImage backGroundImg;


public void setup() {
  size(10, 10);
  surface.setAlwaysOnTop(true);

  /* init fonts */
  fontMap = new HashMap<String, PFont>();
  fontMap.put("h1", createFont("JetBrainsMono.ttf", 24, true));
  fontMap.put("h2", createFont("JetBrainsMono.ttf", 20, true));
  fontMap.put("h3", createFont("JetBrainsMono.ttf", 14, true));
  fontMap.put("p", createFont("JetBrainsMono.ttf", 12, true));

  /* init ui */
  mainUi = new ControlP5(this);
  //mainScreen2D = new Screen2D(this, 5);
  //mainSlicerUi = new SlicerUi(this, fontMap, mainSlicer, mainScreen2D);
  //mainObjectUi = new ObjectUi(this);
  
  int iRes = 20;
  int jRes = 20;
  int kRes = 5;
  mainGrid = new Grid3D(iRes, jRes, kRes, 0.25);
  
  for (int i=1; i<iRes+1; i++) {
    for (int j=1; j<jRes+1; j++) {
      for (int k=1; k<kRes+1; k++) {
        mainGrid.getInitCell(i, j, k).setCharge(Double.valueOf(0));
        mainGrid.getInitCell(i, j, k).setPotential(null);
      }
    }
  }
  
  
  mainGrid.getInitCell((iRes+2)/2, (jRes+2)/2, (kRes+2)/2).setPotential(Double.valueOf(5));
  mainGrid.getInitCell((iRes+2)/2, (jRes+2)/2, (kRes+2)/2).setCharge(null);
  
  mainGrid.solveSystem();
  
  /* fun */
  /*
  backGroundImg = loadImage("greenFN.jpg");
  backGroundImg.resize(200, 200);
  image(backGroundImg, 0, 0);
  
  /* title * /
  System.out.println(fontMap.get("h1"));
  Textlabel title = mainUi.addTextlabel("Title")
                          .setText("Green FN Electrostatics Simulator")
                          .setColor(color(255, 200, 0))
                          .setFont(fontMap.get("h1"))
                          .setPosition(width/2 - 300, 25);
                          
  */
}


public void draw() {
  
}
