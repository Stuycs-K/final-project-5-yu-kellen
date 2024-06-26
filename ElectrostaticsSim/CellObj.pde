 
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
    d - other
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
    if (useExclusion == true) {
      boolean xEin = (x >= xEMin) && (x <= xEMax);
      boolean yEin = (y >= yEMin) && (y <= yEMax);
      boolean zEin = (z >= zEMin) && (z <= zEMax);
      inExclusive = (xEin && yEin && zEin);
    }
    boolean xin = (x >= xMin) && (x <= xMax);
    boolean yin = (y >= yMin) && (y <= yMax);
    boolean zin = (z >= zMin) && (z <= zMax);
    return (xin && yin && zin) && !(inExclusive);
  }
  
  public boolean satisfies(float x, float y, float z) {
    if (isCircular == true) {
      float xVal = xCoeff*pow((x - pos.x), xPow);
      float yVal = yCoeff*pow((y - pos.y), yPow);
      float zVal = zCoeff*pow((z - pos.z), zPow);
      //System.out.println(sqrt(xVal + yVal + zVal) + ", " + radiusMin + ", " + radiusMax);
      return (((xVal + yVal + zVal) >= pow(radiusMin, radiusPow)) && ((xVal + yVal + zVal) <= pow(radiusMax, radiusPow)));
    }
    return true;
  }
  
  public boolean onEdge(float x, float y, float z) {
    float tol = size*1;
    if (isCircular == true) {
      float xVal = xCoeff*pow((x - pos.x), xPow);
      float yVal = yCoeff*pow((y - pos.y), yPow);
      float zVal = zCoeff*pow((z - pos.z), zPow);
      boolean radMin = false;
      if (radiusMin > 0) {
        radMin = (abs((xVal + yVal + zVal) - pow(radiusMin, radiusPow)) < tol);
      }
      boolean radMax = (abs((xVal + yVal + zVal) - pow(radiusMax, radiusPow)) < tol);
      return (radMin || radMax);
    }
    else {
      boolean onInner = false;
      boolean inInnerRange = false;
      if (useExclusion) {
        boolean xEin = (x >= xEMin-size) && (x <= xEMax+size);
        boolean yEin = (y >= yEMin-size) && (y <= yEMax+size);
        boolean zEin = (z >= zEMin-size) && (z <= zEMax+size);
        inInnerRange = (xEin && yEin && zEin);
        onInner = ((abs(x - (xEMin-size)) < tol) || (abs(x - (xEMax+size)) < tol)) || 
                  ((abs(y - (yEMin-size)) < tol) || (abs(y - (yEMax+size)) < tol)) || 
                  ((abs(z - (zEMin-size)) < tol) || (abs(z - (zEMax+size)) < tol));
      }

      boolean onOuter = ((abs(x - xMin) < tol) || (abs(x - xMax) < tol)) ||
                        ((abs(y - yMin) < tol) || (abs(y - yMax) < tol)) || 
                        ((abs(z - zMin) < tol) || (abs(z - zMax) < tol));
                        
      return ((onInner && inInnerRange) || (onOuter && !inInnerRange));
    }
  }
  
  public char getType() {
    return type;
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
