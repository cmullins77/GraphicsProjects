public class Light {
  Vector p = new Vector(0,0,0);
  Vector Cl = new Vector(1,1,1);
  float E;
  
  Vector currentCl = new Vector(1,1,1);
  
  public Vector getShadowVec(Vector P) {
    return null;
  }
  
  public float getMaxDist(Vector P) {
    return -1;
  }
  
  public Vector calculateColor(Hit hit, int depth) {
    return calculateColorFromLight(new Vector(0,0,0), Cl, hit, depth);
  }
    
 public void applyTranslation(Matrix m) {
    return; 
  }
 
 public void applyRotation(Matrix m) {
   return;
 }
} //<>// //<>//

class EnvLight extends Light {
  PImage col; 
  Vector dir;
  
  public EnvLight(Vector col) {
    this.col = new PImage(width, height);
    for (int i = 0; i < this.col.width; i++) {
      for (int j = 0; j < this.col.height; j++) {
        this.col.set(i,j, col.Color()); 
      }
    }
  }
  
  public EnvLight(PImage col) {
    this.col = col;
  }
  
   public Vector calculateColor(Hit hit, int depth) {
    Vector N = hit.n;
    Vector Nt = (N.Add(new Vector(0.1,0,0))).Cross(N);
    Nt.Normalize();
    Vector Nb = N.Cross(Nt);
    
    float theta1 = random(0,radians(180));
    float theta2 = random(0,radians(180));
    
    Vector v1 = Nt.Sub(N.Mult(2*theta1));
    Vector v1Inv = v1.Mult(-1);
    if (v1.Dist(N) > v1Inv.Dist(N)) {
      v1 = v1Inv; 
    }
    Vector v2 = Nb.Sub(N.Mult(2*theta2));
    Vector v2Inv = v2.Mult(-1);
    if (v2.Dist(N) > v2Inv.Dist(N)) {
      v2 = v2Inv; 
    }
    
    dir = v1.Add(v2);
    dir.Normalize();
   
    getCL(hit);
    
     boolean hasShadow = getShadow(this, hit.p, hit.num, 10);
     
      //<>//
     
    currentCl = hasShadow ? new Vector(0,0,0) : Cl;
    
    return calculateColorFromLight(dir, currentCl, hit, depth);
  }
  
  public void getCL(Hit hit) {
    float r = 100000;
    Vector Ph = dir.Mult(r).Add(hit.p); //Npe*Th + Pe
    Vector Nh = Ph.Div(r); //(Ph - Pi)/r
    Nh.Normalize();

    Vector N1 = new Vector(1, 0, 0);
    Vector N0 = new Vector(0, 0, 1);
    Vector N2 = new Vector(0, -1, 0);

   float v = acos(N2.Dot(Ph)/r)/((float)Math.PI);
   float u = acos((N1.Dot(Ph)/r)/sin((float)Math.PI * v))/((float)Math.PI * 2);
   if (N0.Dot(Ph.Sub(P00))/r < 0) {
      u = 1 - u;
    }
    
    int w = col.width;
    int h = col.height;
    Cl = new Vector(col.get((int) (u*w), (int) (v*h)));
  }
  
  public Vector getShadowVec(Vector P) {
    return dir.Add(P);
  }
}

class Point extends Light {
  float range = 2;
  
  public Point(Vector pos, Vector col) {
    p = pos;
    Cl = col;
  }
  
   public Vector calculateColor(Hit hit, int depth) {
    Vector adjustedP = p.Add(new Vector(random(0 - (range/2),range/2),random(0 - (range/2),range/2),random(0 - (range/2),range/2)));
    Vector L = adjustedP.Sub(hit.p);
    L.Normalize();
    
    boolean hasShadow = getShadow(this, hit.p, hit.num, p.Dist(hit.p));
    currentCl = hasShadow ? new Vector(0,0,0) : Cl;
    
    return calculateColorFromLight(L, currentCl, hit, depth);
    }
  
  public Vector getShadowVec(Vector P) {
    Vector adjustedP = p.Add(new Vector(random(0 - (range/2),range/2),random(0 - (range/2),range/2),random(0 - (range/2),range/2)));
    return adjustedP;
  }
  
  public float getMaxDist(Vector P) {
    return P.Dist(p);
  }
  
   public void applyTranslation(Matrix m) {
    p = m.applyMatrixTransform(p);
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
    currentCl = hasShadow ? new Vector(0,0,0) : Cl;
    
    return calculateColorFromLight(dir, currentCl, hit, depth);
  }
  
  public void applyRotation(Matrix m) {
   dir = m.applyMatrixTransform(dir);
 }
  
}

class Spotlight extends Light {
  
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
    currentCl = hasShadow ? new Vector(0,0,0) : Cl;
    return calculateColorFromLight(L, currentCl, hit, depth);
  }
  
  public void applyTranslation(Matrix m) {
    p = m.applyMatrixTransform(p);
  }
  
  public void applyRotation(Matrix m) {
    nl0 = m.applyMatrixTransform(nl0);
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
