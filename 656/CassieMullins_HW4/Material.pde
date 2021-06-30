class Material {
  Vector C0;
  Vector C1;
  Vector Cp;
  float Ks;
  float P;
  
  Vector borderColor;
  float thickness;
  
  public Material(Vector C0, Vector C1, Vector Cp, float Ks, float P, Vector border, float borderThickness) {
    this.C0 = C0;
    this.C1 = C1;
    this.Cp = Cp;
    this.Ks = Ks;
    this.P = P;
    borderColor = border;
    thickness = borderThickness;
  }
}
