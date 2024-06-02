import controlP5.*;

int simulationRes;

Grid3D mainGrid;
Slicer mainSlicer;

int iRes = 100;
int jRes = 1;
int kRes = 100;

float unit = 0.1;

int currSlice = 0;

/* UI */
ControlP5 mainUi;
Screen2D mainScreen2D;

/* Default Fonts */
HashMap<String, PFont> fontMap;

/* Fun */
PImage backGroundImg;
/*
public CellObj(
    PVector initPos,
    float initXCoeff, float initYCoeff, float initZCoeff,
    float initXPow, float initYPow, float initZPow,
    float initXMin, float initXMax,
    float initYMin, float initYMax,
    float initZMin, float initZMax,
    float initRadiusMin, float initRadiusMax,
    float initRadiusPow,
    color initColr,
    char initType,
    float initPerm, Double initCharge, Double initPotential
  ) 
  
*/

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
  mainGrid = new Grid3D(iRes, jRes, kRes, unit);
  mainScreen2D = new Screen2D(this, mainGrid, iRes, jRes, kRes, 10);
  mainSlicer = new Slicer(mainGrid);
  
  CellObj sphere = new CellObj(
                         new PVector(0, 0, 0),
                         1.0, 1.0, 1.0,
                         2.0, 2.0, 2.0,
                         -10.0, 10.0,
                         -10.0, 10.0,
                         -10.0, 10.0,
                         10*unit, 15*unit,
                         2.0,
                         color(255),
                         'd',
                         1.0, Double.valueOf(255), null
                         );
  
  mainGrid.addObject(sphere);
  mainGrid.drawObjects();
  
  mainGrid.solveSystem();
  
  mainScreen2D.setMode('p');
  mainScreen2D.updateMinMaxes();
  mainScreen2D.updateBuffer(mainSlicer.getSlice('j', true, jRes/2));
  
 
  
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

void keyPressed() {
  switch (key) {
    case 'w':
      currSlice++;
      currSlice %= jRes;
      mainScreen2D.updateBuffer(mainSlicer.getSlice('j', true, currSlice));
      System.out.println(currSlice);
      break;
    case 's':
      currSlice--;
      if (currSlice < 0) {
        currSlice = jRes-1;
      }
      mainScreen2D.updateBuffer(mainSlicer.getSlice('j', true, currSlice));
      System.out.println(currSlice);
      break;
    default:
      break;
  }
}


public void draw() {
  
}
