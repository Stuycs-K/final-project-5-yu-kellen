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
              new PVector((i-(iRes+2)/2)*size, (j-(jRes+2)/2)*size, (k-(kRes+2)/2)*size),
              size,
              color(0),
              Double.valueOf(0),
              Double.valueOf(0),
              Cell.pVacuum,
              new PVector(0, 0, 0)
              );
          } else {
            initGrid[i][j][k] = new Cell(
              new PVector((i-(iRes+2)/2)*size, (j-(jRes+2)/2)*size, (k-(kRes+2)/2)*size),
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
              new PVector((i-(iRes+2)/2)*size, (j-(jRes+2)/2)*size, (k-(kRes+2)/2)*size),
              size,
              color(0),
              Double.valueOf(0),
              Double.valueOf(0),
              Cell.pVacuum,
              new PVector(0, 0, 0)
              );
          } else {
            initGrid[i][j][k] = new Cell(
              new PVector((i-(iRes+2)/2)*size, (j-(jRes+2)/2)*size, (k-(kRes+2)/2)*size),
              size,
              color(0),
              Double.valueOf(0),
              null,
              Cell.pVacuum,
              new PVector(0, 0, 0)
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
      for (int i=0; i<iRes; i++) {
        for (int j=0; j<jRes; j++) {
          for (int k=0; k<kRes; k++) {
            Cell cell = getInitCell(i, j, k);
            PVector pos = cell.getCenterPos();
            float x = pos.x;
            float y = pos.y;
            float z = pos.z;
            if (obj.inRange(x, y, z) && obj.satisfies(x, y, z)) {
              cell.setColor(obj.getColor());
              cell.setPerm(obj.getPerm());
              cell.setObj(true);
              switch (obj.getType()) {
                /* conductor, set charges of the edges unknown, make voltage uniform */
                case 'c':
                  cell.setPotential(obj.getPotential());
                  cell.setCharge(Double.valueOf(0));
                  if (obj.onEdge(x, y, z)) {
                    cell.setObj(false);
                    cell.setCharge(null);
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
            yVector.set(index, 0, initGrid[i][j][k].getPotential().doubleValue());
          } 
          else {
            swapTracker[index] = false;
            yVector.set(index, 0, -initGrid[i][j][k].getCharge().doubleValue()/initGrid[i][j][k].getPerm());
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
          if ((i==0)||(j==0)||(k==0)||(i==iRes+1)||(j==jRes+1)||(k==kRes+1)) {
            coeffMatrix.set(index, getIndex(i, j, k), 1);
          }
          else if (swapTracker[index] == true) {
            coeffMatrix.set(index, getIndex(i, j, k), pow(size, 2)/(6.0*initGrid[i][j][k].getPerm()));
            coeffMatrix.set(index, getIndex(i+1, j, k), 1/(6.0));
            coeffMatrix.set(index, getIndex(i-1, j, k), 1/(6.0));
            coeffMatrix.set(index, getIndex(i, j+1, k), 1/(6.0));
            coeffMatrix.set(index, getIndex(i, j-1, k), 1/(6.0));
            coeffMatrix.set(index, getIndex(i, j, k+1), 1/(6.0));
            coeffMatrix.set(index, getIndex(i, j, k-1), 1/(6.0));
          } 
          else {
            /* V */
            coeffMatrix.set(index, getIndex(i, j, k), -6.0/pow(size, 2));
            coeffMatrix.set(index, getIndex(i+1, j, k), 1.0/pow(size, 2));
            coeffMatrix.set(index, getIndex(i-1, j, k), 1.0/pow(size, 2));
            coeffMatrix.set(index, getIndex(i, j+1, k), 1.0/pow(size, 2));
            coeffMatrix.set(index, getIndex(i, j-1, k), 1.0/pow(size, 2));
            coeffMatrix.set(index, getIndex(i, j, k+1), 1.0/pow(size, 2));
            coeffMatrix.set(index, getIndex(i, j, k-1), 1.0/pow(size, 2));

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
            float perm = solvedGrid[i][j][k].getPerm();
            if (swapTracker[index] == true) {
              solvedGrid[i][j][k].setCharge(Double.valueOf(solnVector.get(index, 0)*perm));
            } 
            else {
              solvedGrid[i][j][k].setPotential(Double.valueOf(solnVector.get(index, 0)));
            }
          }
        }
      }
    }
    
    /* solve for field  -E = grad V */
    for (int i=1; i<iRes+1; i++) {
      for (int j=1; j<jRes+1; j++) {
        for (int k=1; k<kRes+1; k++) {
          float dVx = (float)(solvedGrid[i-1][j][k].getPotential().doubleValue() - 
                              2*solvedGrid[i][j][k].getPotential().doubleValue() +
                              solvedGrid[i+1][j][k].getPotential().doubleValue())/pow(size, 2);
                              
          float dVy = (float)(solvedGrid[i][j-1][k].getPotential().doubleValue() - 
                              2*solvedGrid[i][j][k].getPotential().doubleValue() +
                              solvedGrid[i][j+1][k].getPotential().doubleValue())/pow(size, 2);
          
          float dVz = (float)(solvedGrid[i][j][k-1].getPotential().doubleValue() - 
                              2*solvedGrid[i][j][k].getPotential().doubleValue() +
                              solvedGrid[i][j][k+1].getPotential().doubleValue())/pow(size, 2);
                              
          solvedGrid[i][j][k].setEField(new PVector(-dVx, -dVy, -dVz));
        }
      }
    }
        
    /*
    for (int i=0; i<cubeRes; i++) {
      for (int j=0; j<cubeRes; j++) {
        System.out.print(String.format("%3.1f, ", coeffMatrix.get(i, j)));
      }
      System.out.println();
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

  public Cell getSolvedCell(int i, int j, int k) {
    return solvedGrid[i+1][j+1][k+1];
  }

  public float getMaxSolvedPotential() {
    float max = Float.MIN_VALUE;
    for (int i=0; i<iRes; i++) {
      for (int j=0; j<jRes; j++) {
        for (int k=0; k<kRes; k++) {
          float p = (float)getSolvedCell(i, j, k).getPotential().doubleValue();
          boolean isObj = getSolvedCell(i, j, k).isObj();
          if ((p > max) && (!isObj)) {
            max = p;
          }
        }
      }
    }
    return max;
  }


  public float getMinSolvedPotential() {
    float min = Float.MAX_VALUE;
    for (int i=0; i<iRes; i++) {
      for (int j=0; j<jRes; j++) {
        for (int k=0; k<kRes; k++) {
          float p = (float)getSolvedCell(i, j, k).getPotential().doubleValue();
          boolean isObj = getSolvedCell(i, j, k).isObj();
          if ((p < min) && (!isObj)) {
            min = p;
          }
        }
      }
    }
    return min;
  }

  public float getMaxSolvedCharge() {
    float max = Float.MIN_VALUE;
    for (int i=0; i<iRes; i++) {
      for (int j=0; j<jRes; j++) {
        for (int k=0; k<kRes; k++) {
          float p = (float)getSolvedCell(i, j, k).getCharge().doubleValue();
          boolean isObj = getSolvedCell(i, j, k).isObj();
          if ((p > max) && (!isObj)) {
            max = p;
          }
        }
      }
    }
    return max;
  }

  public float getMinSolvedCharge() {
    float min = Float.MAX_VALUE;
    for (int i=0; i<iRes; i++) {
      for (int j=0; j<jRes; j++) {
        for (int k=0; k<kRes; k++) {
          float p = (float)getSolvedCell(i, j, k).getCharge().doubleValue();
          boolean isObj = getSolvedCell(i, j, k).isObj();
          if ((p < min) && (!isObj)) {
            min = p;
          }
        }
      }
    }
    return min;
  }
  
  public float getMaxEMag() {
    float max = Float.MIN_VALUE;
     for (int i=0; i<iRes; i++) {
      for (int j=0; j<jRes; j++) {
        for (int k=0; k<kRes; k++) {
          float u = getSolvedCell(i, j, k).getEField().mag();
          boolean isObj = getSolvedCell(i, j, k).isObj();
          if ((u > max) && (!isObj)) {
            max = u;
          }
        }
      }
     }
     return max;
  }
  
  public float getMinEMag() {
    float min = Float.MAX_VALUE;
     for (int i=0; i<iRes; i++) {
      for (int j=0; j<jRes; j++) {
        for (int k=0; k<kRes; k++) {
          float u = getSolvedCell(i, j, k).getEField().mag();
          boolean isObj = getSolvedCell(i, j, k).isObj();
          if ((u < min) && (!isObj)) {
            min = u;
          }
        }
      }
     }
     return min;
  }

  public Cell getInitCell(int i, int j, int k) {
    return initGrid[i+1][j+1][k+1];
  }
  
  public int getRes(char mode) {
    switch(mode) {
      case 'i':
        return iRes;
     case 'j':
        return jRes;
     case 'k':
        return kRes;
     default:
        return 0;
    }
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
