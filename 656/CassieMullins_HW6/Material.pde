class Material {
  //Vector C0;
  PImage C0Img;
  //Vector C1;
  PImage C1Img;
  //Vector Cp;
  PImage CpImg;
  float Ks;
  float P;
  float tileSize;
  PImage NormalMap;
  
  Vector borderColor;
  float thickness;
  boolean isProjectionTexture = false;
  
  public Material(Vector C0, Vector C1, Vector Cp, float Ks, float P, Vector border, float borderThickness) {
    C0Img = convertColor(C0);
    C1Img = convertColor(C1);
    CpImg = convertColor(Cp);
    this.Ks = Ks;
    this.P = P;
    borderColor = border;
    thickness = borderThickness;
    tileSize = 0.001;
  }
  
  public Material(Vector C0, PImage C1, Vector Cp, float Ks, float P,  float tilingSize, boolean parallel) {
    C0Img = convertColor(C0);
    this.C1Img = C1;
    CpImg = convertColor(Cp);
    this.Ks = Ks;
    this.P = P;
    tileSize = tilingSize;
    this.isProjectionTexture = parallel;
    println(parallel);
    
  }
  
  public Material(PImage C0, PImage C1, PImage Cp, float Ks, float P, float tilingSize) {
    this.C0Img = C0;
    this.C1Img = C1;
    this.CpImg = Cp;
    this.Ks = Ks;
    this.P = P;
    tileSize = tilingSize;
  }
  
  PImage convertColor(Vector c) {
    PImage img = new PImage(width, height);
    for (int i = 0; i < img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        img.set(i,j, c.Color()); 
      }
    }
    return img;
  }
}
