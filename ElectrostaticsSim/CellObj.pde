 
public class CellObj {

  private double xCoeff;
  private double yCoeff;
  private double zCoeff;
  
  private double xOff;
  private double yOff;
  private double zOff;
  
  private double xPow;
  private double yPow;
  private double zPow;

  private double xMin;
  private double xMax;
  private double yMin;
  private double yMax;
  private double zMin;
  private double zMax;
  
  private double radiusPow;
  private double radiusMin;
  private double radiusMax;
  
  private float perm;
  private double charge;
  private double potential;
  
  private char type;
  /*
    c - conductor
    d - dialectric/medium
    p - point charge
  */
  

  public CellObj(
    double initXCoeff, double initYCoeff, double initZCoeff,
    double initXOff, double initYOff, double initZOff,
    double initXPow, double initYPow, double initZPow,
    double initXMin, double initXMax,
    double initYMin, double initYMax,
    double initZMin, double initZMax,
    double initRadiusMin, double initRadiusMax,
    double initRadiusPow
  ) 
  {
    xCoeff = initXCoeff;
    yCoeff = initYCoeff;
    zCoeff = initZCoeff;

    xOff = initXOff;
    yOff = initYOff;
    zOff = initZOff;
    
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
  }
  
  public boolean inRange(double x, double y, double z) {
    boolean xin = (x >= xMin) && (x <= xMax);
    boolean yin = (y >= yMin) && (y <= yMax);
    boolean zin = (z >= zMin) && (z <= zMax);
    return (xin & yin & zin);
  }
  
  public boolean satisfies(double x, double y, double z) {
    double xVal = xCoeff*Math.pow((x - xOff), xPow);
    double yVal = yCoeff*Math.pow((y - yOff), yPow);
    double zVal = zCoeff*Math.pow((z - zOff), zPow);
    double rValMin = Math.pow(radiusMin, radiusPow);
    double rValMax = Math.pow(radiusMax, radiusPow);
    return (((xVal + yVal + zVal) >= radiusMin) && ((xVal + yVal + zVal) <= radiusMax));
  }
  
  public double getXMin() {
    return xMin;
  }
  
  public double getXMax() {
    return xMax;
  }
  
  public double getYMin() {
    return yMin;
  }
  
  public double getYMax() {
    return yMax;
  }
  
  public double getZMin() {
    return zMin;
  }
  
  public double getZMax() {
    return zMax;
  }
  

}
