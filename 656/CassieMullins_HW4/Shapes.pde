public class Shape {
  Material m;
  
  public Hit findHit(Vector Npe) {
    return null; 
  }
}

public class Sphere extends Shape{
  Vector Pi;
  float r;
  Material m;
  
  public Sphere(Vector Pi, float r, Material m) {
    this.Pi = Pi;
    this.r = r;
    this.m = m;
  }
  
  public Hit findHit(Vector Npe) {
    Hit hit = null; //<>//
    Vector a = Pi.Sub(Pe);
    //println(a.toString());
    float b = Npe.Dot(Pi.Sub(Pe));
    float c = (Pe.Sub(Pi)).Dot(Pe.Sub(Pi)) - r*r;
    float delta = b*b - c;
     if (c >= 0 && b >= 0 && delta >= 0 && sqrt(delta) < b) {
        //HIT
        float Th = b - sqrt(delta);
        Vector Ph = Npe.Mult(Th).Add(Pe);
        Vector Nh = Ph.Sub(Pi).Div(r);
        Nh.Normalize();
        
        hit = new Hit(Ph, Nh, m);
     }
    
    return hit;
  }
}

public class Plane extends Shape{
  Vector Pi;
  Vector Ni;
  Material m;
  
  public Plane(Vector Pi, Material m, Vector Ni) {
    this.Pi = Pi;
    this.Ni = Ni;
    this.Ni.Normalize();
    this.m = m;
  }
  
  public Hit findHit(Vector Npe) {
    Hit hit = null;
    if (Ni.Dot(Npe) < 0) {
      float Th = Ni.Mult(-1).Dot(Pe.Sub(Pi))/(Ni.Dot(Npe));
      Vector Ph = Npe.Mult(Th);
      Vector Nh = Ni;
      
      hit = new Hit(Ph, Nh, m);
    }
    return hit;
  }
}

public class Triangle extends Shape {
  Vector P0, P1, P2;
  Vector Ni;
  Material m;
  
  float A;
   int i = 0;
      
  public Triangle(Vector P0, Vector P1, Vector P2, Material m) {
    this.P0 = P0;
    this.P1 = P1;
    this.P2 = P2;
    
    
    Vector E1 = P1.Sub(P0);
    Vector E2 = P2.Sub(P0);
    Ni = E1.Cross(E2);
    Ni.Normalize();
    
    if (Ni.Add(P0).Dist(Pe) > Ni.Mult(-1).Add(P0).Dist(Pe)) {
      Ni = Ni.Mult(-1); 
    }
    
    A = (int)(0.5*E1.Cross(E2).Mag()*100)/100.0f;
    
    this.m = m;
  }
  
  public Hit findHit(Vector Npe) {
    Hit hit = null;
    i++;
    if (Ni.Dot(Npe) < 0) {
      float Th = Ni.Mult(-1).Dot(Pe.Sub(P0))/(Ni.Dot(Npe));
      Vector Ph = Npe.Mult(Th);
      Vector Nh = Ni;
      
      Vector h0 = P0.Sub(Ph);
      Vector h1 = P1.Sub(Ph);
      Vector h2 = P2.Sub(Ph);
      
      float A01 = 0.5*h0.Cross(h1).Mag();
      float A12 = 0.5*h1.Cross(h2).Mag();
      float A20 = 0.5*h2.Cross(h0).Mag();
      float newA = (int)((A01 + A12 + A20)*100)/100.0f;

      if (A >= newA) {
        hit = new Hit(Ph, Nh, m); 
      }
    }
    return hit;
  }
}

public class Square extends Shape {
  Triangle t1;
  Triangle t2;
      
  public Square(Vector Pi, Vector n0, Vector n1, float s0, float s1, Material m) {
    n0.Normalize();
    n1.Normalize();
    Vector P0 = Pi.Sub(n0.Mult(s0/2)).Sub(n1.Mult(s1/2));
    Vector P1 = P0.Add(n1.Mult(s1));
    Vector P2 = P0.Add(n0.Mult(s0));
    Vector P3 = P1.Add(n0.Mult(s0));
    t1 = new Triangle(P1,P2,P0,m);
    t2 = new Triangle(P1,P2,P3,m);
  }
  
  public Hit findHit(Vector Npe) {
    Hit hit = t1.findHit(Npe);
    if (hit == null) {
      hit = t2.findHit(Npe); 
    }
    return hit;
  }
}

public class Quadric extends Shape{
  Vector Pi;
  Material m;
  
  int a02, a12, a22, a21, a00;
  float s0, s1,s2;
  
  Vector V2;
  Vector Vup;
  
  Vector n0, n1, n2;
  
  
  public Quadric(int A02, int A12, int A22, int A21, int A00, float S0, float S1, float S2, Vector View2, Vector Up, Vector Pc, Material m) {
    a02 = A02;
    a12 = A12;
    a22 = A22;
    a21 = A21;
    a00 = A00;
    
    s0 = S0;
    s1 = S1;
    s2 = S2;
    
    V2 = View2;
    Vup = Up;
    
    Pi = Pc;
    
    n2 = View2;
    n2.Normalize();
    
    n0 = V2.Cross(Vup);
    n0.Normalize();
    
    n1 = n0.Cross(n2);
    
    println(n0 + " " + n1 + " " + n2);
    this.m = m;
  }
  
  public Hit findHit(Vector Npe) {
    Hit hit = null;
    
    float eyeCheck = 0;
    eyeCheck += sumFunct(a02, Pe, n0, s0, 2);
    eyeCheck += sumFunct(a12, Pe, n1, s1, 2);
    eyeCheck += sumFunct(a22, Pe, n2, s2, 2);
    eyeCheck += sumFunct(a21, Pe, n2, s2, 1);
    eyeCheck += a00;
    
    //println(eyeCheck);
    if (eyeCheck >= 0) {
      float A = a02*pow(n0.Dot(Npe)/s0, 2) + a12*pow(n1.Dot(Npe)/s1, 2) + a22*pow(n2.Dot(Npe)/s2, 2);
      float B = a02*(2*n0.Dot(Npe)*n0.Dot(Pe.Sub(Pi))/s0*s0) + a12*(2*n1.Dot(Npe)*n1.Dot(Pe.Sub(Pi))/s1*s1) + a22*(2*n2.Dot(Npe)*n2.Dot(Pe.Sub(Pi))/s2*s2) + a21*(n2.Dot(Npe)/s2);
      float C = a02*pow(n0.Dot(Pe.Sub(Pi))/s0,2) + a12*pow(n1.Dot(Pe.Sub(Pi))/s1,2) + a22*pow(n2.Dot(Pe.Sub(Pi))/s2,2) + a21*n2.Dot(Pe.Sub(Pi))/s2 + a00;
      
      float checkNum1 = 2*A;
      float checkNum2 = B*B - 4*A*C;
      
     // println(checkNum1 + " " + checkNum2);
      if (checkNum1 != 0 && checkNum2 >= 0) {        
        float t1 = (-1 * B + sqrt(B*B - 4*A*C))/2*A;
        float t2 = (-1 * B - sqrt(B*B - 4*A*C))/2*A; 
        //println (t1 + " " + t2);
        if (t1 > 0 && t2 >0) {
          float th = min(t1,t2);
          Vector Ph = Pe.Add(Npe.Mult(th));
          Vector Nh = n0.Mult(2*a02*(n0.Dot(Ph.Sub(Pi))/s0*s0)).Add(n1.Mult(2*a12*(n1.Dot(Ph.Sub(Pi))/s1*s1))).Add(n2.Mult(2*a22*(n2.Dot(Ph.Sub(Pi))/s2*s2))).Add(n2.Mult(a21/s2));
          Nh.Normalize();
          hit = new Hit(Ph, Nh, m);
          //println(Ph.toString() + " " + Nh.toString());
        }
      }
    }
    //Vector a = Pi.Sub(Pe);
    ////println(a.toString());
    //float b = Npe.Dot(Pi.Sub(Pe));
    //float c = (Pe.Sub(Pi)).Dot(Pe.Sub(Pi)) - r*r;
    //float delta = b*b - c;
    // if (c >= 0 && b >= 0 && delta >= 0 && sqrt(delta) < b) {
    //    //HIT
    //    float Th = b - sqrt(delta);
    //    Vector Ph = Npe.Mult(Th).Add(Pe);
    //    Vector Nh = Ph.Sub(Pi).Div(r);
    //    Nh.Normalize();
        
    //    hit = new Hit(Ph, Nh, m);
    // }
    
    return hit;
  }
  
  private float sumFunct(float a, Vector P, Vector n, float s, float power) {
    return a*pow((n.Dot(P.Sub(Pi)))/s, power);
  }
}
