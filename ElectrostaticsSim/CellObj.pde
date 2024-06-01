 
public class CellObj {
  private PVector pos;

  private float xCoeff;
  private float yCoeff;
  private float zCoeff;
  
  private float xPow;
  private float yPow;
  private float zPow;

  private float xMin;
  private float xMax;
  private float yMin;
  private float yMax;
  private float zMin;
  private float zMax;

  public CellObj(
    float initXCoeff, float initYCoeff, float initZCoeff,
    float initXPow, float initYPow, float initZPow,
    float initXMin, float initXMax,
    float initYMin, float initYMax,
    float initZMin, float initZMax
  ) 
  {
    xCoeff = initXCoeff;
    yCoeff = initYCoeff;
    zCoeff = initZCoeff;

    xPow = initXPow;
    yPow = initYPow;
    zPow = initZPow;

    xMin = initXMin;
    xMax = initXMax;
    yMin = initYMin;
    yMax = initYMax;
    zMin = initZMin;
    zMax = initZMax;
  }
 

  
}
