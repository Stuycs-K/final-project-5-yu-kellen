public class Material {
  private float perm;
  private Double charge;
  private Double potential;
  private char type;
  private String name;
  private color colr;
  
  public Material(
    String initName, float initPerm, 
    char initType, Double initCharge, Double initPotential,
    color initColr
    )
  {
    name = initName;
    type = initType;
    perm = initPerm;
    charge = initCharge;
    potential = initPotential;
    colr = initColr;
  }
  
  public float getPerm() {
    return perm;
  }
  
  public char getType() {
    return type;
  }
  
  public Double getCharge() {
    return charge;
  }
  
  public Double getPotential() {
    return potential;
  }
  
  public String getName() {
    return name;
  }
  
  public color getColor() {
    return colr;
  }
}
