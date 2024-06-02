 
public class CellObj {
  private float size;
  
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
  
  private boolean useExclusion;
  
  private float xEMin;
  private float xEMax;
  private float yEMin;
  private float yEMax;
  private float zEMin;
  private float zEMax;
  
  private boolean isCircular;
  
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
    float initSize,
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
    boolean initIsCircular,
    float initRadiusMin, float initRadiusMax,
    float initRadiusPow,
    color initColr,
    char initType,
    float initPerm, Double initCharge, Double initPotential
  ) 
  {
    size = initSize;
    
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
    
    useExclusion = initUseExclusion;
    
    xEMin = initXEMin;
    xEMax = initXEMax;
    yEMin = initYEMin;
    yEMax = initYEMax;
    zEMin = initZEMin;
    zEMax = initZEMax;
    
    isCircular = initIsCircular;
    
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
    boolean inExclusive = false;
    if (useExclusion) {
      boolean xEin = (x >= xEMin) && (x <= xEMax);
      boolean yEin = (y >= yEMin) && (y <= yEMax);
      boolean zEin = (z >= zEMin) && (z <= zEMax);
      inExclusive = (xEin && yEin && zEin);
    }
    boolean xin = (x >= xMin) && (x <= xMax);
    boolean yin = (y >= yMin) && (y <= yMax);
    boolean zin = (z >= zMin) && (z <= zMax);
    return (xin && yin && zin) && !inExclusive;
  }
  
  public boolean satisfies(float x, float y, float z) {
    if (isCircular) {
      float xVal = xCoeff*pow((x - pos.x), xPow);
      float yVal = yCoeff*pow((y - pos.y), yPow);
      float zVal = zCoeff*pow((z - pos.z), zPow);
      //System.out.println(sqrt(xVal + yVal + zVal) + ", " + radiusMin + ", " + radiusMax);
      return ((sqrt(xVal + yVal + zVal) >= radiusMin) && (sqrt(xVal + yVal + zVal) <= radiusMax));
    }
    return true;
  }

  public boolean onEdge(float x, float y, float z) {
    float tol = size*1;
    if (isCircular) {
      float xVal = xCoeff*pow((x - pos.x), xPow);
      float yVal = yCoeff*pow((y - pos.y), yPow);
      float zVal = zCoeff*pow((z - pos.z), zPow);
      boolean radMin = (abs(sqrt(xVal + yVal + zVal) - radiusMin) < tol);
      boolean radMax = (abs(sqrt(xVal + yVal + zVal) - radiusMax) < tol);
      return (radMin || radMax);
    }
    else {
      boolean onInner = false;
      if (useExclusion) {
        onInner = ((abs(x - xEMin) < tol) || (abs(x - xEMax) < tol)) || 
                  ((abs(y - yEMin) < tol) || (abs(y - yEMax) < tol)) || 
                  ((abs(z - zEMin) < tol) || (abs(z - zEMax) < tol));
      }
      boolean onOuter = ((abs(x - xMin) < tol) || (abs(x - xMax) < tol)) ||
                        ((abs(y - yMin) < tol) || (abs(y - yMax) < tol)) || 
                        ((abs(z - zMin) < tol) || (abs(z - zMax) < tol));
      return (onInner || onOuter);
    }
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
