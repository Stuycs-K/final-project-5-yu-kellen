import org.ejml.simple.SimpleMatrix;
import org.ejml.data.DMatrixSparseCSC;
import org.ejml.data.DMatrixRMaj;
import org.ejml.sparse.csc.CommonOps_DSCC;

import java.util.*;

public class Grid3D {
  /* res x res x res grid */
  private int iRes, jRes, kRes;
  /* size of each cell */
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
    /* initialize objectList */
    objList = new ArrayList<CellObj>();

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
          } else {
            initGrid[i][j][k] = new Cell(
              new PVector(i*size, j*size, k*size),
              size
              );
          }
        }
      }
    }
  }
  
  //set everything to a vaccumm and of charge zero, field zero. Potential is unknown
  public void clearGrid() {
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
          } else {
            initGrid[i][j][k] = new Cell(
              new PVector(i*size, j*size, k*size),
              size
              );
          }
        }
      }
    }
  }
  
  public void addObject(CellObj obj) {
    objList.add(obj);
  }
  

  public void drawObjects() {
    clearGrid();
    for (CellObj obj : objList) {
      System.out.println(obj);
      for (int i=0; i<iRes; i++) {
        for (int j=0; j<jRes; j++) {
          for (int k=0; k<kRes; k++) {
            float x = size*i;
            float y = size*j;
            float z = size*k;
            if (obj.inRange(x, y, z) && obj.satisfies(x, y, z)) {
              System.out.println("E");
              Cell cell = getInitCell(i, j, k);
              cell.setColor(obj.getColor());
              cell.setPerm(obj.getPerm());
              switch (obj.getType()) {
                /* conductor, set charges of the edges unknown, make voltage uniform */
                case 'c':
                  cell.setPotential(obj.getPotential());
                  cell.setCharge(null);
                  if (!obj.onMinEdge(x, y, z) || !obj.onMaxEdge(x, y, z)) {
                    cell.setCharge(Double.valueOf(0));
                  }
                  break;
                case 'd':
                  cell.setPotential(obj.getPotential());
                  cell.setCharge(obj.getCharge());
                  break;
                default:
                  break;
              }
            }
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
    DMatrixSparseCSC coeffMatrix = new DMatrixSparseCSC (cubeRes, cubeRes, 8*cubeRes);
    DMatrixRMaj yVector = new DMatrixRMaj(cubeRes, 1);
    DMatrixRMaj solnVector = new DMatrixRMaj(cubeRes, 1);

    /* tracks if charge and potential are swapped */
    boolean[] swapTracker = new boolean[cubeRes];

    long start2 = System.nanoTime();

    for (int i=0; i<iRes+2; i++) {
      for (int j=0; j<jRes+2; j++) {
        for (int k=0; k<kRes+2; k++) {
          int index = getIndex(i, j, k);
          solvedGrid[i][j][k] = new Cell(initGrid[i][j][k]);

          /* potential != null */
          //System.out.println(initGrid[i][j][k].getCharge());
          if (initGrid[i][j][k].getCharge() == null) {
            swapTracker[index] = true;
            yVector.set(index, 0, (-1)*initGrid[i][j][k].getPotential().doubleValue());
          } else {
            swapTracker[index] = false;
            yVector.set(index, 0, initGrid[i][j][k].getCharge().doubleValue());
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
          } else {
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
    
    CommonOps_DSCC.solve(coeffMatrix, yVector, solnVector);

    long end4 = System.nanoTime();


    /* update solved grid */
    for (int i=0; i<iRes+2; i++) {
      for (int j=0; j<jRes+2; j++) {
        for (int k=0; k<kRes+2; k++) {
          if (!((i==0)||(j==0)||(k==0)||(i==iRes+1)||(j==jRes+1)||(k==kRes+1))) {
            int index = getIndex(i, j, k);
            if (swapTracker[index] == true) {
              solvedGrid[i][j][k].setCharge(Double.valueOf(solnVector.get(index, 0)));
            } else {
              solvedGrid[i][j][k].setPotential(Double.valueOf(solnVector.get(index, 0)));
            }
          }
        }
      }
    }

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

  public Cell getSolvedCell(int i, int j, int k) {
    return solvedGrid[i+1][j+1][k+1];
  }

  public float getMaxSolvedPotential() {
    float max = (float)getSolvedCell(0, 0, 0).getPotential().doubleValue();
    for (int i=0; i<iRes; i++) {
      for (int j=0; j<jRes; j++) {
        for (int k=0; k<kRes; k++) {
          float p = (float)getSolvedCell(i, j, k).getPotential().doubleValue();
          if (p > max) {
            max = p;
          }
        }
      }
    }
    return max;
  }


  public float getMinSolvedPotential() {
    float min = (float)getSolvedCell(0, 0, 0).getPotential().doubleValue();
    for (int i=0; i<iRes; i++) {
      for (int j=0; j<jRes; j++) {
        for (int k=0; k<kRes; k++) {
          float p = (float)getSolvedCell(i, j, k).getPotential().doubleValue();
          if (p < min) {
            min = p;
          }
        }
      }
    }
    return min;
  }

  public float getMaxSolvedCharge() {
    float max = (float)getSolvedCell(0, 0, 0).getCharge().doubleValue();
    for (int i=0; i<iRes; i++) {
      for (int j=0; j<jRes; j++) {
        for (int k=0; k<kRes; k++) {
          float p = (float)getSolvedCell(i, j, k).getCharge().doubleValue();
          if (p > max) {
            max = p;
          }
        }
      }
    }
    return max;
  }

  public float getMinSolvedCharge() {
    float min = (float)getSolvedCell(0, 0, 0).getCharge().doubleValue();
    for (int i=0; i<iRes; i++) {
      for (int j=0; j<jRes; j++) {
        for (int k=0; k<kRes; k++) {
          float p = (float)getSolvedCell(i, j, k).getCharge().doubleValue();
          if (p < min) {
            min = p;
          }
        }
      }
    }
    return min;
  }

  public Cell getInitCell(int i, int j, int k) {
    return initGrid[i+1][j+1][k+1];
  }

  public int getIRes() {
    return iRes;
  }

  public int getjRes() {
    return jRes;
  }

  public int getkRes() {
    return kRes;
  }
}
