public class Light {
  Vector p = new Vector(0,0,0);
  Vector Cl = new Vector(1,1,1);
  
  public Vector getLightVector(Vector Ph) {
    return null;
  }
}

class Point extends Light {
  
  public Point(Vector pos, Vector col) {
    p = pos;
    Cl = col;
  }
  
  public Vector getLightVector(Vector Ph) {
    Vector L = p.Sub(Ph);
    L.Normalize();
    return L;
  }
}

class Direction extends Light {
  Vector dir;
  public Direction(Vector direction, Vector col) {
    dir = direction;
    dir.Normalize();
    Cl = col;
  }
  
  public Vector getLightVector(Vector Ph) {
    return dir;
  }
}

class Spotlight extends Light {
  
  float E;
  Vector nl0;
  
  public Spotlight(Vector pos, Vector n, Vector col, float e) {
    p = pos;
    Cl = col;
    E = e;
    nl0 = n;
    nl0.Normalize();
  }
  
  public Vector getLightVector(Vector Ph) {
    Vector nl1 = p.Sub(Ph);
    nl1.Normalize();
    float value = nl0.Mult(-1).Dot(nl1);
    Vector L = nl0.Mult(-1).Dot(nl1) <= E ? new Vector(0,0,0) : nl1;
    //println(value);
    return L;
  }
}
