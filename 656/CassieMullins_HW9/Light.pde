public class Light {
  Vector p = new Vector(0,0,0);
  Vector Cl = new Vector(1,1,1);
  
  Vector currentCl = new Vector(1,1,1);
  
  public Vector getLightVector(Vector Ph) {
    return null;
  }
  
  public Vector getShadowVec(Vector P) {
    return null;
  }
  
  public float getMaxDist(Vector P) {
    return -1;
  }
  
  public Vector calculateColor(Hit hit, int depth) {
    return calculateColorFromLight(new Vector(0,0,0), Cl, hit, false, depth);
    }
}

class Point extends Light {
  
  public Point(Vector pos, Vector col) {
    p = pos;
    Cl = col;
  }
  
   public Vector calculateColor(Hit hit, int depth) {
    Vector L = p.Sub(hit.p);
    L.Normalize();
    
    boolean hasShadow = getShadow(this, hit.p, hit.num, p.Dist(hit.p));
    currentCl = hasShadow ? new Vector(0,0,0) : Cl;
    
    return calculateColorFromLight(L, currentCl, hit, false, depth);
    }
  
  public Vector getShadowVec(Vector P) {
    return p;
  }
  
  public float getMaxDist(Vector P) {
    return P.Dist(p);
  }
}

class Direction extends Light {
  Vector dir;
  public Direction(Vector direction, Vector col) {
    dir = direction;
    dir.Normalize();
    Cl = col;
  }
  
   public Vector getShadowVec(Vector P) {
    return dir.Add(P);
  }
  
  public float getMaxDist(Vector P) {
    return -1;
  }
  
  public Vector calculateColor(Hit hit, int depth) {
    
    boolean hasShadow = getShadow(this, hit.p, hit.num, -1);
    return calculateColorFromLight(dir, Cl, hit, hasShadow, depth);
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
  
   public Vector getShadowVec(Vector P) {
    return p;
  }
  
   public float getMaxDist(Vector P) {
    return P.Dist(p);
  }
  
  public Vector calculateColor(Hit hit, int depth) {
    Vector nl1 = p.Sub(hit.p);
    nl1.Normalize();
    Vector L = nl0.Mult(-1).Dot(nl1) <= E ? new Vector(0,0,0) : nl1;
    
    boolean hasShadow = getShadow(this, hit.p, hit.num, p.Dist(hit.p));
    return calculateColorFromLight(L, Cl, hit, hasShadow, depth);
  }
  
}

class RectangleArea extends Light {
   //P = p00
   float s0;
   float s1;
   
   Vector n0,n1,n2;
   
   int count0, count1;
   
   ArrayList<Point> pointLights;
   
   public RectangleArea(Vector p00, Vector col, float s0, float s1, Vector forward, Vector up, int count0, int count1) {
     Cl = col;
     p = p00;
     this.s0 = s0;
     this.s1 = s1;
     
     this.count0 = count0;
     this.count1 = count1;
     
     n2 = forward;
     n2.Normalize();
     
     n0 = forward.Cross(up);
     n0.Normalize();
     
     n1 = n0.Cross(n2);
     
     pointLights = new ArrayList<Point>();
     float distanceI = s0/count0;
     float distanceJ = s1/count1;
     for (float i = 0; i < s0; i+= distanceI) {
      for (float j = 0; j < s1; j+= distanceJ) {
        float newI = i + random(0, distanceI);
        float newJ = j + random(0, distanceI);
        Vector pointP = p.Add(n0.Mult(newI)).Add(n1.Mult(newJ));
        Point pointLight = new Point(pointP, Cl);
        pointLights.add(pointLight);
      }
     }
   }
   
   public Vector calculateColor(Hit hit, int depth) {
    Vector finalColor = new Vector(0,0,0);
    
    for (Point light : pointLights) {
      Vector pointCol = light.calculateColor(hit, depth);
      finalColor = finalColor.Add(pointCol.Div(pointLights.size()));
    }
    return finalColor;
  }
}
