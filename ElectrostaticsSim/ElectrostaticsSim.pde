import controlP5.*;

int simulationRes;

Grid3D mainGrid;
Slicer mainSlicer;

int iRes = 20;
int jRes = 20;
int kRes = 20;

float unit = 0.0001;

int currSlice = 5;

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
    boolean initUseExclusion,
    float initXEMin, float initXEMax,
    float initYEMin, float initYEMax,
    float initZEMin, float initZEMax,
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
                         unit,
                         new PVector(0, 0, 0),
                         1.0, 1.0, 1.0,
                         2.0, 2.0, 2.0,
                         -20*unit, 20*unit,
                         -20*unit, 20*unit,
                         -20*unit, 20*unit,
                         true,
                         -7*unit, 7*unit,
                         -7*unit, 7*unit,
                         -7*unit, 7*unit,
                         false,
                         5*unit, 12*unit,
                         1.0,
                         color(255),
                         'c',
                         8.8541878188E-12, null, Double.valueOf(0)
                         );
                         
  CellObj ball = new CellObj(
                         unit,
                         new PVector(0, 0, 0),
                         1.0, 1.0, 1.0,
                         2.0, 2.0, 2.0,
                         -10.0, 10.0,
                         -10.0, 10.0,
                         -10.0, 10.0,
                         false,
                         -5*unit, 5*unit,
                         -5*unit, 5*unit,
                         -5*unit, 5*unit,
                         true,
                         0*unit, 0*unit,
                         1.0,
                         color(255),
                         'd',
                         8.8541878188E-12, Double.valueOf(1), null
                         );
  
  //mainGrid.addObject(sphere);
  mainGrid.addObject(ball);
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
