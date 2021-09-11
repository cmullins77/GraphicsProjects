class Material {
  PImage C0Img;
  PImage C1Img;
  
  PImage CpImg; //Specular Color
  float Ks; //Amount Specular
  float P; //Shininess for Specular
  
  float tileSize;
  PImage NormalMap;
  
  float Krefl; //Amount Reflection
  float Krefr; //Amount Refraction
  PImage N; //Refraction Constant
  boolean isRefractionTexture = false;
  
  float drtRange = 0;
  
  Shape envMap;
  
  Vector borderColor;
  float thickness;
  boolean isProjectionTexture = false;
  boolean isSmoothShading = false;
  
  public Material() {
    tileSize = 0.001;
    C0Img = convertColor(new Vector(0,0,0));
    C1Img = convertColor(new Vector(1,1,1));
    CpImg = convertColor(new Vector(1,1,1));
    Ks = 0;
    P = 1000;
    Krefl = 0;
    Krefr = 0;
    N = convertColor(new Vector(0,0,0));
    envMap = null;
  }
  
  public void animateColor(Vector change, int type) {
    PImage img = type == 0 ? C0Img : type == 1 ? C1Img : type == 2 ? CpImg : N; //<>// //<>//
    for (int i = 0; i < img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        Vector c = new Vector(img.get(i,j));
        c = c.Add(change);
        c.x = c.x < 0 ? 0 : c.x > 1 ? 1 : c.x;
        c.y = c.y < 0 ? 0 : c.y > 1 ? 1 : c.y;
        c.z = c.z < 0 ? 0 : c.z > 1 ? 1 : c.z;
        img.set(i,j, c.Color());
      }
    }
  }
  
  public void addColor(Vector C, int type) {
    PImage Col = convertColor(C);
    if (type == 0) {
      C0Img = Col;
    } else if (type == 1) {
      C1Img = Col;
    } else {
      CpImg = Col; 
    }
  }
  
  public void addColor(PImage Col, int type) {
    if (type == 0) {
      C0Img = Col;
    } else if (type == 1) {
      C1Img = Col;
    } else {
      CpImg = Col; 
    }
  }
  
  public PImage convertColor(Vector c) {
    PImage img = new PImage(width, height);
    for (int i = 0; i < img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        img.set(i,j, c.Color()); 
      }
    }
    return img;
  }
}
