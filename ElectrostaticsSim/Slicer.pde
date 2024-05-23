
public class Slicer {
  private Gric3D grid;

  public class Slicer(Grid3D grid) {
    this.grid = grid;
  }


  /*
  Mode:
   'x' render yz, h = x
   'y' render xz, h = y
   'z' render xy, h = z
   */
  public Cell[] getSlice(char mode, int index) {
    int res = grid.getRes();
    Cell[] out = new Cell[res][res];
    switch (mode) {
      /* yz */
      case 'x':
        for (int j=0; j<res; j++) {
          for (int k=0; k<res; k++) {
            out[j][z] = grid.getCell(index, j, k);
        }
        break;
      case 'y':
        break;
      case 'z':
        break;
      default:
        break;
    }
  }
}
