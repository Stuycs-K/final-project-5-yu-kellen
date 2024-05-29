
public class Cell {
  /* size length of the cell in units */
  private float size;
  /* cosmetics */
  private color colr;
  /* position of center */
  private PVector centerPos;
  
  /* constructors */
  public Cell(PVector initCenterPos, float initSize) {
    this(initCenterPos, initSize, color(255));
  }
  
  public Cell(PVector initCenterPos, float initSize, color initColr) {
    centerPos = initCenterPos;
    size = initSize;
    colr = initColr; 
  }
  
  /* modifier methods */
  
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
