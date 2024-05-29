
public class Slicer {
  private Grid3D grid;
  
  public Slicer(Grid3D initGrid) {
    grid = initGrid;
  }
  
  /*
  Mode:
   'i' render jk, select by row
   'j' render ik, select by column
   'k' render ij, select by layer
   */
  public Cell[][] getSlice(char mode, int index) {
    int res = grid.getRes();
    Cell[][] out = new Cell[res][res];
    switch (mode) {
      /* jk */
      case 'i':
        for (int k=0; k<res; k++) {
          for (int j=0; j<res; j++) {
            out[k][j] = grid.getCell(index, j, k);
          }
        }
        break;
      /* ik */
      case 'j':
        for (int i=0; i<res; i++) {
          for (int k=0; k<res; k++) {
            out[i][k] = grid.getCell(i, index, k);
          }
        }
        break;
      /* ij */
      case 'k':
        for (int i=0; i<res; i++) {
          for (int j=0; j<res; j++) {
            out[i][j] = grid.getCell(i, j, index);
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
