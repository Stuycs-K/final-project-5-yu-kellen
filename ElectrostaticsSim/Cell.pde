
public class Cell {
  /* size length of the cell in units */
  public static final float pVacuum = 8.8541878188E-12;
  private float size;
  private Double charge;
  private Double potential;
  private float perm;
  private PVector eField;
  /* cosmetics */
  private color colr;
  /* position of center */
  private PVector centerPos;
  private boolean isObj;
  
  /* constructors */
  public Cell(Cell other) {
    if (other.getCharge() != null) {
      charge = Double.valueOf(other.getCharge().doubleValue());
    }
    if (other.getPotential() != null) {
      potential = Double.valueOf(other.getPotential().doubleValue());
    }
    if (other.getEField() != null) {
      eField = eField = other.getEField().copy();
    }
    centerPos = other.getCenterPos().copy();
    size = other.getSize();
    colr = other.getColor();
    perm = other.getPerm();
    isObj = false;
  }
  
  public Cell(PVector initCenterPos, float initSize) {
    this(initCenterPos, initSize, color(255));
  }
  
  /* initializes it to be unknown */
  public Cell(PVector initCenterPos, float initSize, color initColr) {
    this(initCenterPos, initSize, initColr, Double.valueOf(0), null, pVacuum, null);
  }
  
  public Cell(
    PVector initCenterPos,
    float initSize,
    color initColr,
    Double initCharge,
    Double initPotential,
    float initPerm,
    PVector initEField
    )
  {
    centerPos = initCenterPos;
    size = initSize;
    colr = initColr; 
    charge = initCharge;
    potential = initPotential;
    perm = initPerm;
    eField = initEField;
  }
  
  /* modifier methods */
  public void setEField(PVector newEField) {
    eField = newEField;
  }
  
  public void setCharge(Double newCharge) {
    charge = newCharge;
  }
  
  public void setPotential(Double newPotential) {
    potential = newPotential;
  }
  
  public void setPerm(float newPerm) {
    perm = newPerm;
  }
  
  public void changeSize(float newSize) {
    /* also changes the centerPos */
    float scale = newSize/size;
    size = newSize;
    centerPos.mult(scale);
  }
  
  public void setColor(color newColor) {
    colr = newColor;
  }
  
  public void setObjStatus(boolean newIsObj) {
    isObj = newIsObj;
  }
  
  /* accessor methods */
  
  public PVector getEField() {
    return eField;
  }
  
  public Double getCharge() {
    return charge;
  }
  
  public Double getPotential() {
    return potential;
  }
  
  public float getPerm() {
    return perm;
  }
  
  public float getSize() {
    return size;
  }
  
  public color getColor() {
    return colr;
  }
  
  public boolean isObj() {
    return isObj;
  }
  
  public PVector getCenterPos() {
    return centerPos;
  }
  
}
