 
public class CellObj {
  private PVector pos;
  
  private float xCoeff;
  private float yCoeff;
  private float zCoeff;
  
  private float xPow;
  private float yPow;
  private float zPow;

  private float xMin;
  private float xMax;
  private float yMin;
  private float yMax;
  private float zMin;
  private float zMax;
  
  private float radiusPow;
  private float radiusMin;
  private float radiusMax;
  
  private float perm;
  private Double charge;
  private Double potential;
  
  private color colr;
  
  private char type;
  /*
    c - conductor
    d - whatever other things exist
  */
  

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
  {
    pos = initPos;
    
    xCoeff = initXCoeff;
    yCoeff = initYCoeff;
    zCoeff = initZCoeff;

    xPow = initXPow;
    yPow = initYPow;
    zPow = initZPow;

    xMin = initXMin;
    xMax = initXMax;
    yMin = initYMin;
    yMax = initYMax;
    zMin = initZMin;
    zMax = initZMax;
    
    radiusMin = initRadiusMin;
    radiusMax = initRadiusMax;
    
    radiusPow = initRadiusPow;
    
    colr = initColr;
    
    type = initType;
    
    perm = initPerm;
    charge = initCharge;
    potential = initPotential;
  }
  
  public boolean inRange(float x, float y, float z) {
    boolean xin = (x >= xMin) && (x <= xMax);
    boolean yin = (y >= yMin) && (y <= yMax);
    boolean zin = (z >= zMin) && (z <= zMax);
    return (xin && yin && zin);
  }
  
  public boolean satisfies(float x, float y, float z) {
    float xVal = xCoeff*pow((x - pos.x), xPow);
    float yVal = yCoeff*pow((y - pos.y), yPow);
    float zVal = zCoeff*pow((z - pos.z), zPow);
    //System.out.println(sqrt(xVal + yVal + zVal) + ", " + radiusMin + ", " + radiusMax);
    return ((sqrt(xVal + yVal + zVal) >= radiusMin) && (sqrt(xVal + yVal + zVal) <= radiusMax));
  }
  
  public boolean onMinEdge(float x, float y, float z) {
    float xVal = xCoeff*pow((x - pos.x), xPow);
    float yVal = yCoeff*pow((y - pos.y), yPow);
    float zVal = zCoeff*pow((z - pos.z), zPow);
    return (sqrt(xVal + yVal + zVal) == radiusMin);
  }
  
  public boolean onMaxEdge(float x, float y, float z) {
    float xVal = xCoeff*pow((x - pos.x), xPow);
    float yVal = yCoeff*pow((y - pos.y), yPow);
    float zVal = zCoeff*pow((z - pos.z), zPow);
    return (sqrt(xVal + yVal + zVal) == radiusMax);
  }
  
  public char getType() {
    return type;
  }
 
  
  public float getXMin() {
    return xMin;
  }
  
  public float getXMax() {
    return xMax;
  }
  
  public float getYMin() {
    return yMin;
  }
  
  public float getYMax() {
    return yMax;
  }
  
  public float getZMin() {
    return zMin;
  }
  
  public float getZMax() {
    return zMax;
  }
  
  public float getPerm() {
    return perm;
  }
  
  public Double getCharge() {
    return charge;
  }
  
  public Double getPotential() {
    return potential;
  }
  
  public color getColor() {
    return colr;
  }
  

}
