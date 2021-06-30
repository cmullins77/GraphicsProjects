public class Hit {
  Vector p;
  Vector n;
  Material m;
  int num;
  Vector uv;
  
  Shape s;
  
  public Hit(Vector p, Vector n, Material m, int num, Shape s) {
    this.p = p;
    this.n = n;
    this.m = m;
    this.num = num;
    this.s = s;
    uv = new Vector(0,0,0);
  }
  
   public Hit(Vector p, Vector n, Material m, int num, Vector uv) {
    this.p = p;
    this.n = n;
    this.m = m;
    this.num = num;
    this.uv = uv;
  }
  
  public Vector getC0() {
    int w = m.C0Img.width;
    int h = m.C0Img.height;
    Vector c0 = new Vector(m.C0Img.get((int) (uv.x*w), (int) (uv.y*h)));
    return c0;
  }
  
  public Vector getC1() {
    int w = m.C1Img.width;
    int h = m.C1Img.height;
    Vector c1 = new Vector(m.C1Img.get((int) (uv.x*w), (int) (uv.y*h)));
    return c1;
  }
  
  public Vector getCP() {
    int w = m.CpImg.width;
    int h = m.CpImg.height;
    Vector cP = new Vector(m.CpImg.get((int) (uv.x*w), (int) (uv.y*h)));
    return cP;
  }
}

public class Ray {
  Vector origin;
  Vector direction;
  
  public Ray(Vector o, Vector d) {
    origin = o;
    direction = d;
  }
  
  public Vector getDir() {
    Vector n = direction.Sub(origin);
    n.Normalize();
    return n;
  }
}
