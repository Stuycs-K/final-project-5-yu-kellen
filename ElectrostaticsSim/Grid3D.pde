import org.hipparchus.linear.*;

public class Grid3D {
  /* res x res x res grid */
  private int res;
  /* actual size length of the grid in units */
  private int size;
  /* z, y, x */
  private Cell initGrid[][][];
  private Cell solvedGrid[][][];
  
  /* colleciton of objects */
  private ArrayList<CellObj> objList;
  
  /* initRes > initSize, initSize must be divisible by initRes */
  public Grid3D(int initRes, int initSize, ArrayList<CellObj> initObjList) {
    res = size;
    size = size;
    objList = initObjList;
    
    /* initialize grid */
    /* edges not included */
    initGrid = new Cell[res+2][res+2][res+2];
    
    /* initialize grid cells */
    for (int i=0; i<res+2; i++) {
      for (int j=0; j<res+2; j++) {
        for (int k=0; k<res+2; k++) {
          /* Boundary conditions */
          if ((i==0)||(j==0)||(k==0)||(i==res-1)||(j==res-1)||(k==res-1)) {
            initGrid[i][j][k] = new Cell(
                                    new PVector(i*size/res, j*size/res, k*size/res), 
                                    size/res,
                                    color(0),
                                    new Double(0),
                                    new Double(0),
                                    Cell.pVacuum,
                                    new PVector(0, 0, 0)
                                    );
          }
          else {  
            initGrid[i][j][k] = new Cell(new PVector(i*size/res, j*size/res, k*size/res), size/res);
          }
        }
      }
    }

    
  }
  
  /* solve Poisson's equations using FDM for p, V, and E */
  public void solveSystem() {
    int realRes = (res+2);
    int cubeRes = (int)pow((res+2), 3);
    solvedGrid = new Cell[realRes][realRes][realRes];
    
    /* potential is the main unknown quantity */
    OpenMapRealMatrix coeffMatrix = new OpenMapRealMatrix(cubeRes, cubeRes);
    RealVector yVector = new ArrayRealVector(cubeRes);
    RealVector solnVector;
   
   /* tracks if charge and potential are swapped */
    boolean[] swapTracker = new boolean[(int)pow((res+2), 3)];

    for (int i=0; i<res+2; i++) {
      for (int j=0; j<res+2; j++) {
        for (int k=0; k<res+2; k++) {
          int index = getIndex(i, j, k);
          solvedGrid[i][j][k] = initGrid[i][j][k];
          
          /* potential != null */
          if (initGrid[i][j][k].getCharge() == null) {
            swapTracker[index] = true;
            yVector.setEntry(index, initGrid[i][j][k].getPotential().doubleValue());
          }
          else {
            swapTracker[index] = false;
            yVector.setEntry(index, initGrid[i][j][k].getCharge().doubleValue());
          } 
        }
      }
    }
    
    
  }
  
  public int getIndex(int i, int j, int k) {
    return i + (res+2)*j + (res+2)*(res+2)*k;
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
