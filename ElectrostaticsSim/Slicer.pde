
public class Slicer {
  private Grid3D grid;
  
  public Slicer(Grid3D initGrid) {
    grid = initGrid;
  }
  
  /*
  Mode:
   'x' render yz, h = x
   'y' render xz, h = y
   'z' render xy, h = z
   */
  public Cell[][] getSlice(char mode, int index) {
    int res = grid.getRes();
    Cell[][] out = new Cell[res][res];
    switch (mode) {
      /* yz */
      case 'x':
        for (int j=0; j<res; j++) {
          for (int k=0; k<res; k++) {
            out[j][k] = grid.getCell(index, j, k);
          }
        }
        break;
      /* xz */
      case 'y':
        for (int k=0; k<res; k++) {
          for (int i=0; i<res; i++) {
            out[k][i] = grid.getCell(i, index, k);
          }
        }
        break;
      /* xy */
      case 'z':
        for (int j=0; j<res; j++) {
          for (int i=0; i<res; i++) {
            out[j][i] = grid.getCell(i, j, index);
          }
        }
        break;
      default:
        break;
    }
    return out;
  }
  
  public int getRes() {
    return grid.getRes();
  }
  
}
