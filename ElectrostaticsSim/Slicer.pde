
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
  public Cell[][] getSlice(char sliceMode, boolean isSolved, int index) {
    int iRes = grid.getIRes();
    int jRes = grid.getjRes();
    int kRes = grid.getkRes();
    Cell[][] out;
    switch (sliceMode) {
      /* jk */
      case 'i':
        out = new Cell[kRes][jRes];
        for (int k=0; k<kRes; k++) {
          for (int j=0; j<jRes; j++) {
            out[k][j] = (isSolved) ? grid.getSolvedCell(index, j, k) : grid.getInitCell(index, j, k);
          }
        }
        break;
      /* ik */
      case 'j':
        out = new Cell[iRes][kRes];
        for (int i=0; i<iRes; i++) {
          for (int k=0; k<kRes; k++) {
            out[i][k] = (isSolved) ? grid.getSolvedCell(i, index, k) : grid.getInitCell(i, index, k);
          }
        }
        break;
      /* ij */
      case 'k':
        out = new Cell[iRes][jRes];
        for (int i=0; i<iRes; i++) {
          for (int j=0; j<jRes; j++) {
            out[i][j] = (isSolved) ? grid.getSolvedCell(i, j, index) : grid.getInitCell(i, j, index);
          }
        }
        break;
      default:
        out = new Cell[iRes][jRes];
        break;
    }
    return out;
  }
  
}
