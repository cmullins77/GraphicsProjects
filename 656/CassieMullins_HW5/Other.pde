public class Hit {
  Vector p;
  Vector n;
  Material m;
  int num;
  
  public Hit(Vector p, Vector n, Material m, int num) {
    this.p = p;
    this.n = n;
    this.m = m;
    this.num = num;
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
