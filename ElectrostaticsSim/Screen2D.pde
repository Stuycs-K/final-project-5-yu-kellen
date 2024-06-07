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
  
  public final float[][] colorScalePlasma = {
    {13, 8, 135}, 
    {74, 3, 168}, 
    {125, 3, 168}, 
    {168, 34, 150}, 
    {203, 70, 121}, 
    {227, 109, 90}, 
    {248, 148, 65}, 
    {252, 194, 52}, 
    {249, 241, 78}
  };
  
  public final float[][] colorScaleVirdis = {
    {68, 1, 84}, 
    {71, 44, 122}, 
    {59, 81, 139}, 
    {44, 113, 142}, 
    {33, 144, 140}, 
    {39, 173, 129}, 
    {92, 200, 99}, 
    {170, 220, 50}, 
    {253, 231, 37}
  };
  
  public final int colorRes = 256;
  
  public color[] potentialColors;
  public color[] chargeColors;
  
  float minP; 
  float maxP;
  float minC;
  float maxC;
  float minEMag;
  float maxEMag;
  
  private Cell[][] buffer;
  private Grid3D grid;
 
  private char renderMode;
  private char sliceMode;
  
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
    sliceMode = 'j';
    buffer = new Cell[screenRes][screenRes];
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  
  public void setup() {
    surface.setTitle("Render Output");
    surface.setAlwaysOnTop(true);
    potentialColors = createScaleColors(colorScalePlasma, colorRes);
    chargeColors = createScaleColors(colorScaleVirdis, colorRes);
  }
  
  public void settings() {
    size(screenRes*scale, screenRes*scale);
  }
  
  public void draw() {
    float val;
    float ratio;
    color colorVal;
    PVector eField;
    PVector eField2D;
    fill(color(0));
    stroke(color(0));
    rect(0, 0, width, height);
    if (buffer[0][0] != null) {
      for (int i=0; i<buffer.length; i++) {
        for (int j=0; j<buffer[i].length; j++) {
          if (!buffer[i][j].isObj()) {
            switch (renderMode) {
              case 'v':
                push();
                eField = buffer[i][j].getEField();
                switch (sliceMode) {
                  case 'i':
                    eField2D = new PVector(eField.z, eField.y);
                    break;
                  case 'j':
                    eField2D = new PVector(eField.x, eField.z);
                    break;
                  case 'k':
                    eField2D = new PVector(eField.x, eField.y);
                    break;
                  default:
                     eField2D = new PVector(eField.x, eField.y);
                    break;
                }
                translate((i+0.5)*scale, (j+0.5)*scale);
                rotate(eField2D.heading());
                System.out.println(eField2D.heading());
                fill(255);
                stroke(255);
                line(-(float)scale/2 + 2, 0, (float)scale/2 - 2, 0);
                translate((float)scale/2 - 2, 0);
                pop();
                break;
              case 'l':
                break;
              case 'p':
                colorMode(RGB, 255);
                val = (float)buffer[i][j].getPotential().doubleValue();
                ratio = map(val, minP, maxP, 0, 1);
                ratio = pow(ratio, 0.5);
                if (ratio > 1) { ratio = 1; }
                if (ratio < 0) { ratio = 0; }
                colorVal = potentialColors[int(ratio*(colorRes-1))];
                fill(colorVal);
                stroke(colorVal);
                rect(
                  (i+(screenRes - buffer.length)/2)*scale, 
                  (j+(screenRes - buffer[i].length)/2)*scale, 
                  scale, scale
                  );
                break;
              case 'c':
                colorMode(RGB, 255);
                val = (float)buffer[i][j].getCharge().doubleValue();
                ratio = map(val, minC, maxC, 0, 1);
                ratio = pow(ratio, 0.5);
                if (ratio >= 1) { ratio = 1; }
                if (ratio <= 0) { ratio = 0; }
                colorVal = chargeColors[int(ratio*(colorRes-1))];
                fill(colorVal);
                stroke(colorVal);
                rect(
                  (i+(screenRes - buffer.length)/2)*scale, 
                  (j+(screenRes - buffer[i].length)/2)*scale, 
                  scale, scale
                  );
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
  
  public void setSliceMode(char newMode) {
    sliceMode = newMode;
  }
  
  public void updateBuffer(Cell[][] newBuffer) {
    buffer = newBuffer;
    
   System.out.println();
    for (int i=0; i<buffer.length; i++) {
      for (int j=0; j<buffer[i].length; j++) {
        System.out.print(buffer[i][j].getEField() + ", ");
      }
      System.out.println();
    }
    
    
  }
  
  public void updateMinMaxes() {
    minP = grid.getMinSolvedPotential();
    maxP = grid.getMaxSolvedPotential();
    minC = grid.getMinSolvedCharge();
    maxC = grid.getMaxSolvedCharge();
    minEMag = grid.getMinEMag();
    maxEMag = grid.getMaxEMag();
    System.out.println(String.format("P: %ev, %ev C: %ec, %ec", minP, maxP, minC, maxC));
  }
  
  color[] createScaleColors(float[][] colorVals, int res) {
    color[] colors = new color[res];
    for (int i = 0; i < res; i++) {
      float t = map(i, 0, res-1, 0, 1);
      colors[i] = lerpColor(colorVals, t);
    }
    return colors;
  }

  color lerpColor(float[][] colorArray, float t) {
    int n = colorArray.length;
    int index = int(t * (n - 1));
    float weight = t * (n - 1) - index;
    float[] c1 = colorArray[index];
    float[] c2 = colorArray[min(index + 1, n - 1)];
    int r = int(lerp(c1[0], c2[0], weight));
    int g = int(lerp(c1[1], c2[1], weight));
    int b = int(lerp(c1[2], c2[2], weight));
    return color(r, g, b);
  }
  
}
