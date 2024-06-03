
public class Interpreter {
  private Grid3D grid;
  private Screen2D screen;
  private Slicer slicer;
  
  public Interpreter() {
  }
  
  /* How a program is formatted
  BEGIN: int X, int Y, int Z, float U, int PPC; #Init grid of size X, Y, Z, cell units U, pixel per cell PPC
  MAT matName epsilon, type, associated val; - define a material with some permittibity
  BOX mat, pX, pY, pZ, sX, sY, sZ #define a box of center (pX, pY, pZ) and size sX, sY, sZ
  HBOX mat, pX, pY, pZ, sX, sY, sZ, T
  HBOX mat, pX, pY, pZ, sX, sY, sZ, iX, iY, iZ
  HBOX mat, pX, pY, pZ, sX, sY, sZ, pIX, pIY, pIZ, iX, iY, iZ
  SPHERE pX, pY, pZ, R
  HSPHERE pX1, pY1, pZ1, R1, R2 #outer rad, inner rad
  HSPHERE pX1, pY1, pZ1, R1, pX2, pY2, pZ2 #outer rad, inner rad, move inner box
  POINT pX, pY, pZ #point of whatever
  */
  
  public void run(String program) {
    HashMap<String, Material> matMap = new HashMap<String, Material>();
    Scanner scanner = new Scanner(program);
    if (!scanner.hasNext()) {
      throw new IllegalArgumentException("Incorrect code format!");
    }
    /* init Grid, slicer, screen */
    while (scanner.hasNext()) {
      String word = scanner.next();
      switch (word) {
        case "BEGIN":
          if ((grid==null)&&(screen == null)&&(slicer == null)) {
            throw new IllegalArgumentException("Already initialized!");
          }
          int iRes = scanner.nextInt();
          int jRes = scanner.nextInt();
          int kRes = scanner.nextInt();
          break;
        case "MAT":
          break;
        case "BOX":
          break;
        case "HBOX":
          break;
        case "SPHERE":
          break;
        case "HSPHERE":
          break;  
        case "POINT":
          break;
        default:
          break;
        
         
      }
      
    }
    
  }
  
}
