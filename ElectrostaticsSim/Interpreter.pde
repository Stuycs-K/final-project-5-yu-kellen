import java.io.*;

public class Interpreter {
  private Grid3D grid;
  private Screen2D screen;
  private Slicer slicer;
  private PApplet parent;
  
  public Interpreter(PApplet initParent) {
    parent = initParent;
  }
  
  public Grid3D getGrid() {
    return grid;
  }
  
  public Slicer getSlicer() {
    return slicer;
  }
  
  public Screen2D getScreen2D() {
    return screen;
  }
  
  /* How a program is formatted
  BEGIN: int X, int Y, int Z, float U, int PPC; #Init grid of size X, Y, Z, cell units U, pixel per cell PPC
  MAT matName epsilon, type, associated val; - define a material with some permittibity
  BOX mat, pX, pY, pZ, sX, sY, sZ #define a box of center (pX, pY, pZ) and size sX, sY, sZ
  HBOX mat, pX, pY, pZ, sX, sY, sZ, T
  SPHERE pX, pY, pZ, R
  HSPHERE pX1, pY1, pZ1, R1, R2 #outer rad, inner rad
  HSPHERE pX1, pY1, pZ1, R1, pX2, pY2, pZ2 #outer rad, inner rad, move inner box
  POINT pX, pY, pZ #point of whatever
  SOLVE
  */
  
  public void run(File program) {
    try {
      HashMap<String, Material> matMap = new HashMap<String, Material>();
      int iRes=0, jRes=0, kRes=0;
      int PPC=1;
      float units=1.0;
      Scanner scanner = new Scanner(program);
      if (!scanner.hasNext()) {
        scanner.close();
        throw new IllegalArgumentException("Incorrect code format!");
      }
      /* init Grid, slicer, screen */
      while (scanner.hasNext()) {
        String word = scanner.next();
        switch (word) {
          case "BEGIN": {
            iRes = scanner.nextInt();
            jRes = scanner.nextInt();
            kRes = scanner.nextInt();
            units = scanner.nextFloat();
            PPC = scanner.nextInt();
            grid = new Grid3D(iRes, jRes, kRes, units);
            slicer = new Slicer(grid);
            break;
          }
          case "MAT": {
            String matName = scanner.next();
            float perm = scanner.nextFloat();
            char type = scanner.next().charAt(0);
            Double charge = null;
            Double potential = null;
            switch (type) {
              case 'c':
                potential = Double.valueOf(scanner.nextDouble());
                break;
              case 'd':
                charge = Double.valueOf(scanner.nextDouble());
              default:
                break;
            }
            Material mat = new Material(matName, perm, type, charge, potential);
            matMap.put(matName, mat);
            System.out.println(matMap);
            break;
          }
          case "BOX": {
            Material mat = matMap.get(scanner.next());
            float pX = scanner.nextFloat()*units;
            float pY = scanner.nextFloat()*units;
            float pZ = scanner.nextFloat()*units;
            float sX = scanner.nextFloat()*units;
            float sY = scanner.nextFloat()*units;
            float sZ = scanner.nextFloat()*units;
            grid.addObject(new CellObj(
                           units,
                           new PVector(pX, pY, pZ),
                           0.0, 0.0, 0.0,
                           1.0, 1.0, 1.0,
                           (-sX/2)+pX, (sX/2)+pX,
                           (-sY/2)+pY, (sY/2)+pY,
                           (-sZ/2)+pZ, (sZ/2)+pZ,
                           false,
                           0.0, 0.0,
                           0.0, 0.0,
                           0.0, 0.0,
                           false,
                           0.0, 0.0,
                           1.0,
                           color(200),
                           mat.getType(),
                           mat.getPerm(), mat.getCharge(), mat.getPotential()
                           )
                           );
            break;
          }
          case "HBOX": {
            Material mat = matMap.get(scanner.next());
            float pX = scanner.nextFloat()*units;
            float pY = scanner.nextFloat()*units;
            float pZ = scanner.nextFloat()*units;
            float sX = scanner.nextFloat()*units;
            float sY = scanner.nextFloat()*units;
            float sZ = scanner.nextFloat()*units;
            float t = scanner.nextFloat()*units;
            grid.addObject(new CellObj(
                           units,
                           new PVector(pX, pY, pZ),
                           0.0, 0.0, 0.0,
                           0.0, 0.0, 0.0,
                           (-sX/2)+pX, (sX/2)+pX,
                           (-sY/2)+pY, (sY/2)+pY,
                           (-sZ/2)+pZ, (sZ/2)+pZ,
                           true,
                           (-sX/2)+pX+t, (sX/2)+pX-t,
                           (-sY/2)+pY+t, (sY/2)+pY-t,
                           (-sZ/2)+pZ+t, (sZ/2)+pZ-t,
                           false,
                           1.0, 1.0,
                           1.0,
                           color(200),
                           mat.getType(),
                           mat.getPerm(), mat.getCharge(), mat.getPotential()
                           )
                           );
            break;
          }

          case "SPHERE": {
            Material mat = matMap.get(scanner.next());
            float pX = scanner.nextFloat()*units;
            float pY = scanner.nextFloat()*units;
            float pZ = scanner.nextFloat()*units;
            float r = scanner.nextFloat()*units;
            grid.addObject(new CellObj(
                           units,
                           new PVector(pX, pY, pZ),
                           1.0, 1.0, 1.0,
                           2.0, 2.0, 2.0,
                           -iRes*units, iRes*units,
                           -jRes*units, jRes*units,
                           -kRes*units, kRes*units,
                           false,
                           1.0, 1.0,
                           1.0, 1.0,
                           1.0, 1.0,
                           true,
                           0.0, r,
                           2.0,
                           color(200),
                           mat.getType(),
                           mat.getPerm(), mat.getCharge(), mat.getPotential()
                           )
                           );
            break;
          }
          case "HSPHERE": {
            Material mat = matMap.get(scanner.next());
            float pX = scanner.nextFloat()*units;
            float pY = scanner.nextFloat()*units;
            float pZ = scanner.nextFloat()*units;
            float r1 = scanner.nextFloat()*units;
            float r2 = scanner.nextFloat()*units;
            grid.addObject(new CellObj(
                           units,
                           new PVector(pX, pY, pZ),
                           1.0, 1.0, 1.0,
                           2.0, 2.0, 2.0,
                           -iRes*units, iRes*units,
                           -jRes*units, jRes*units,
                           -kRes*units, kRes*units,
                           false,
                           1.0, 1.0,
                           1.0, 1.0,
                           1.0, 1.0,
                           true,
                           r1, r2,
                           2.0,
                           color(200),
                           mat.getType(),
                           mat.getPerm(), mat.getCharge(), mat.getPotential()
                           )
                           );
            break;
          }
          case "POINT": {
            Material mat = matMap.get(scanner.next());
            float pX = scanner.nextFloat()*units;
            float pY = scanner.nextFloat()*units;
            float pZ = scanner.nextFloat()*units;
            grid.addObject(new CellObj(
                           units,
                           new PVector(pX, pY, pZ),
                           1.0, 1.0, 1.0,
                           1.0, 1.0, 1.0,
                           pX, pX,
                           pY, pY,
                           pZ, pZ,
                           false,
                           1.0, 1.0,
                           1.0, 1.0,
                           1.0, 1.0,
                           false,
                           1.0, 1.0,
                           1.0,
                           color(200),
                           mat.getType(),
                           mat.getPerm(), mat.getCharge(), mat.getPotential()
                           )
                           );
            break;
          }
          case "SOLVE":
            grid.drawObjects();
            grid.solveSystem();
            screen = new Screen2D(parent, grid, iRes, jRes, kRes, PPC);
            screen.updateMinMaxes();
            screen.updateBuffer(slicer.getSlice('j', true, 0));
            break;
          default:
            break;
        }
        
      }
      
    }
    catch (FileNotFoundException e) {
      System.out.println("ERROR: FILE DOES NOT EXIST!");
    }
    
  }
  
}
