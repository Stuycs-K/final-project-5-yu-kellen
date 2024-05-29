
public class Grid3D {
  /* res x res x res grid */
  private int res;
  /* actual size length of the grid in units */
  private int size;
  /* z, y, x */
  private Cell grid[][][];
  /* colleciton of objects */
  private ArrayList<CellObj> objList;
  
  /* initRes > initSize, initSize must be divisible by initRes */
  public Grid3D(int initRes, int initSize, ArrayList<CellObj> initObjList) {
    res = size;
    size = size;
    objList = initObjList;
    
    /* initialize grid */
    grid = new Cell[res][res][res];
    
    /* initialize grid cells */
    for (int i=0; i<res; i++) {
      for (int j=0; j<res; j++) {
        for (int k=0; k<res; k++) {
          grid[i][j][k] = new Cell(new PVector(i*size/res, j*size/res, k*size/res), size/res);
        }
      }
    }
    
  }
  
  /* changes size of grid */ 
  public void changeSize() {
  }
  
  public void setCell(int i, int j, int k, Cell newCell) {
    grid[i][j][k] = newCell;
  }
  
  public Cell getCell(int i, int j, int k) { 
    return grid[i][j][k];
  }
  
  public int getRes() {
    return res;
  }
  
  
}
