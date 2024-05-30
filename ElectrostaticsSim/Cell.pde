
public class Cell {
  /* size length of the cell in units */
  private final static float pVacuum  = 8.8541878188 * pow(10, -12);
  private float size;
  private Double charge;
  private Double potential;
  private float perm;
  private PVector eField;
  /* cosmetics */
  private color colr;
  /* position of center */
  private PVector centerPos;
  
  /* constructors */
  public Cell(PVector initCenterPos, float initSize) {
    this(initCenterPos, initSize, color(255));
  }
  
  /* initializes it to be unknown */
  public Cell(PVector initCenterPos, float initSize, color initColr) {
    this(initCenterPos, initSize, initColr, null, null, pVacuum, null);
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
  
  public void changeColor(color newColor) {
    colr = newColor;
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
  
  public PVector getCenterPos() {
    return centerPos;
  }
  
}
