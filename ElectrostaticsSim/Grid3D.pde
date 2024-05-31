import static jeigen.Shortcuts.*;
import java.util.*;

public class Grid3D {
  /* res x res x res grid */
  private int iRes, jRes, kRes;
  /* actual size length of the grid in units */
  private float size;
  /* z, y, x */
  private Cell initGrid[][][];
  private Cell solvedGrid[][][];
  
  /* colleciton of objects */
  private ArrayList<CellObj> objList;
  
  /* initRes > initSize, initSize must be divisible by initRes */
  public Grid3D(int initIRes, int initJRes, int initKRes, float initSize) {
    iRes = initIRes;
    jRes = initJRes;
    kRes = initKRes;
    size = initSize;
    
    /* initialize grid */
    /* edges not included */
    initGrid = new Cell[iRes+2][jRes+2][kRes+2];
    
    /* initialize grid cells */
    for (int i=0; i<iRes+2; i++) {
      for (int j=0; j<jRes+2; j++) {
        for (int k=0; k<kRes+2; k++) {
          /* Boundary conditions */
          if ((i==0)||(j==0)||(k==0)||(i==iRes+1)||(j==jRes+1)||(k==kRes+1)) {
            initGrid[i][j][k] = new Cell(
                                    new PVector(i*size, j*size, k*size), 
                                    size,
                                    color(0),
                                    Double.valueOf(0),
                                    Double.valueOf(0),
                                    Cell.pVacuum,
                                    new PVector(0, 0, 0)
                                    );
          }
          else {  
            initGrid[i][j][k] = new Cell(
                                     new PVector(i*size, j*size, k*size), 
                                     size
                                     );
          }
        }
      }
    }
  }
  
  
  
  /* solve Poisson's equations using FDM for p, V, and E */
  public void solveSystem() {
    long start1 = System.nanoTime();
    int cubeRes = (iRes+2)*(jRes+2)*(kRes+2);
    solvedGrid = new Cell[iRes+2][jRes+2][kRes+2];
    
    /* potential is the main unknown quantity */
    DenseMatrix coeffMatrix = zeros(cubeRes, cubeRes);
    DenseMatrix yVector = zeros(cubeRes, 1);
    DenseMatrix solnVector;
   
   /* tracks if charge and potential are swapped */
    boolean[] swapTracker = new boolean[cubeRes];
    
    long start2 = System.nanoTime();

    for (int i=0; i<iRes+2; i++) {
      for (int j=0; j<jRes+2; j++) {
        for (int k=0; k<kRes+2; k++) {
          int index = getIndex(i, j, k);
          solvedGrid[i][j][k] = initGrid[i][j][k];
          
          /* potential != null */
          //System.out.println(initGrid[i][j][k].getCharge());
          if (initGrid[i][j][k].getCharge() == null) {
            swapTracker[index] = true;
            yVector.set(index, (-1)*initGrid[i][j][k].getPotential().doubleValue());
          }
          else {
            swapTracker[index] = false;
            yVector.set(index, initGrid[i][j][k].getCharge().doubleValue());
          } 
        }
      }
    }
    
    long end2 = System.nanoTime();
    long start3 = System.nanoTime();
    
    /* init CoeffMatrix */
    for (int i=0; i<iRes+2; i++) {
      for (int j=0; j<jRes+2; j++) {
        for (int k=0; k<kRes+2; k++) {
          int index = getIndex(i, j, k);
          if (swapTracker[index] == true) {
            /* V */
            coeffMatrix.set(index, getIndex(i, j, k), 1/(6.0));
            /* V(i+d) */
            if (i < iRes+1) {
              coeffMatrix.set(index, getIndex(i+1, j, k), solvedGrid[i+1][j][k].getPerm()/6);
            }
            /* V(i-d) */
            if (i > 0) {
              coeffMatrix.set(index, getIndex(i-1, j, k), solvedGrid[i-1][j][k].getPerm()/6);
            }
            /* V(j+d) */
            if (j < jRes+1) {
              coeffMatrix.set(index, getIndex(i, j+1, k), solvedGrid[i][j+1][k].getPerm()/6);
            }
            /* V(j-d) */
            if (j > 0) {
              coeffMatrix.set(index, getIndex(i, j-1, k), solvedGrid[i][j-1][k].getPerm()/6);
            }
            /* V(k+d) */
            if (k < kRes+1) {
              coeffMatrix.set(index, getIndex(i, j, k+1), solvedGrid[i][j][k+1].getPerm()/6);
            }
            /* V(k-d) */
            if (k > 0) {
              coeffMatrix.set(index, getIndex(i, j, k-1), solvedGrid[i][j][k-1].getPerm()/6);
            }
          }
          else { 
            /* V */
            coeffMatrix.set(index, getIndex(i, j, k), 6*solvedGrid[i][j][k].getPerm()/pow(solvedGrid[i][j][k].getSize(), 2));
            /* V(i+d) */
            if (i < iRes+1) {
              coeffMatrix.set(index, getIndex(i+1, j, k), -solvedGrid[i+1][j][k].getPerm()/pow(solvedGrid[i+1][j][k].getSize(), 2));
            }
            /* V(i-d) */
            if (i > 0) {
              coeffMatrix.set(index, getIndex(i-1, j, k), -solvedGrid[i-1][j][k].getPerm()/pow(solvedGrid[i-1][j][k].getSize(), 2));
            }
            /* V(j+d) */
            if (j < jRes+1) {
              coeffMatrix.set(index, getIndex(i, j+1, k), -solvedGrid[i][j+1][k].getPerm()/pow(solvedGrid[i][j+1][k].getSize(), 2));
            }
            /* V(j-d) */
            if (j > 0) {
              coeffMatrix.set(index, getIndex(i, j-1, k), -solvedGrid[i][j-1][k].getPerm()/pow(solvedGrid[i][j-1][k].getSize(), 2));
            }
            /* V(k+d) */
            if (k < kRes+1) {
              coeffMatrix.set(index, getIndex(i, j, k+1), -solvedGrid[i][j][k+1].getPerm()/pow(solvedGrid[i][j][k+1].getSize(), 2));
            }
            /* V(k-d) */
            if (k > 0) {
              coeffMatrix.set(index, getIndex(i, j, k-1), -solvedGrid[i][j][k-1].getPerm()/pow(solvedGrid[i][j][k-1].getSize(), 2));
            }
          }
        }
      }
    }
  
    long end3 = System.nanoTime();
    
    long start4 = System.nanoTime();
    
   /* solve! */

   solnVector = coeffMatrix.ldltSolve(yVector);
   
   long end4 = System.nanoTime();
   
   
   /* update solved grid */
   for (int i=0; i<iRes+2; i++) {
      for (int j=0; j<jRes+2; j++) {
        for (int k=0; k<kRes+2; k++) {
          if (!((i==0)||(j==0)||(k==0)||(i==iRes+1)||(j==jRes+1)||(k==kRes+1))) {
            int index = getIndex(i, j, k);
            if (swapTracker[index] == true) {
              solvedGrid[i][j][k].setCharge(Double.valueOf(solnVector.get(index, 0)));
            }
            else {
              solvedGrid[i][j][k].setPotential(Double.valueOf(solnVector.get(index, 0)));
            }
          }
        }
      }
    }
    
    /*
    
    //System.out.println(realRes);
    float[][] charges = new float[realRes][realRes];
    
    for (int k=0; k<realRes; k++) {
      
    for (int i=0; i<realRes; i++) {
      for (int y=0; y<realRes; y++) {
        charges[i][y] = (float)solvedGrid[i][k][y].getPotential().doubleValue();
      }
    }
    
    for (int i=0; i<realRes; i++) {
      for (int y=0; y<realRes; y++) {
        System.out.print(String.format("%03.3f ", charges[i][y]));
      }
      System.out.println();
    }
    System.out.println("\n" + k);
    }
  }
  */
  long end1 = System.nanoTime();
  System.out.println("T1: " + ((float)(end1 - start1))/pow(10, 9));
  System.out.println("T2: " + ((float)(end2 - start2))/pow(10, 9));
  System.out.println("T3: " + ((float)(end3 - start3))/pow(10, 9));
  System.out.println("T4: " + ((float)(end4 - start4))/pow(10, 9));
  System.out.println("DONE");
}
  

  
  public int getIndex(int i, int j, int k) {
    return i + (iRes+2)*j + (iRes+2)*(jRes+2)*k;
  }
  
  /* changes size of grid */ 
  public void changeSize() {
  }
  
  /*
  public void setCell(int i, int j, int k, Cell newCell) {
    grid[i][j][k] = newCell;
  }
  */
  
  public Cell getCell(int i, int j, int k) { 
    return solvedGrid[i][j][k];
  }
  
  public Cell getInitCell(int i, int j, int k) { 
    return initGrid[i][j][k];
  }
  
  public int getRes() {
    return 0;
  }
  
}
