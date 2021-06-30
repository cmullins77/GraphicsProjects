public class Hit {
  Vector p;
  Vector n;
  Material m;
  
  public Hit(Vector p, Vector n, Material m) {
    this.p = p;
    this.n = n;
    this.m = m;
  }
}
