
public class Cell {
  /* size length of the cell in units */
  private int size;
  private color colr;
  private PVector pos;
  
  /* constructors */
  public Cell(PVector initPos, int initSize) {
    this(initPos, initSize, color(255));
  }
  
  public Cell(PVector initPos, int initSize, color initColr) {
    pos = initPos;
    size = initSize;
    colr = initColr;
  }
  
  
  /* modifier methods */
  
  public void changeSize(int newSize) {
    size = newSize;
  }
  
  public void changeColor(color newColor) {
    colr = newColor;
  }
  
  /* accessor methods */
  
  public int getSize() {
    return size;
  }
  
  public color getColor() {
    return colr;
  }
  
}
