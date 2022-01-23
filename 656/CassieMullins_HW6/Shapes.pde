public class Shape {
  Material m;
  int num;
  
  public Hit findHit(Ray ray) {
    return null; 
  }
}

public class Sphere extends Shape {
  Vector Pi;
  float r;
  Material m;
  
  public Sphere(Vector Pi, float r, Material m, int n) {
    this.Pi = Pi;
    this.r = r;
    this.m = m;
    num = n;
  }
  
  public Hit findHit(Ray ray) {
    Vector o = ray.origin;
    Vector n = ray.getDir(); //Get unit vector version of ray (Npe)
    Hit hit = null;
    
    float b = n.Dot(Pi.Sub(o)); //Npe DOT (Pi - Pe)
    float c = (o.Sub(Pi)).Dot(o.Sub(Pi)) - r*r; // (Pe - Pi) DOT (Pe - Pi)
    float delta = b*b - c;
     if (c >= 0 && b >= 0 && delta >= 0 && sqrt(delta) < b) {
        float Th = b - sqrt(delta);
        Vector Ph = n.Mult(Th).Add(o); //Npe*Th + Pe
        Vector Nh = Ph.Sub(Pi).Div(r); //(Ph - Pi)/r
        Nh.Normalize();
        
          Vector uv = new Vector(0,0,0);
          if (m.isProjectionTexture) {
            uv = new Vector(currentU, currentV, 0);
          } else {
            Vector N1 = new Vector(1, 0, 0);
            Vector N0 = new Vector(0, 0, 1);
            Vector N2 = new Vector(0, -1, 0);
            //Calculate Texture UV
            float v = acos(N2.Dot(Ph.Sub(Pi))/r)/((float)Math.PI);
            float u = acos((N1.Dot(Ph.Sub(Pi))/r)/sin((float)Math.PI * v))/((float)Math.PI * 2);
            if (N0.Dot(Ph.Sub(P00))/r < 0) {
               u = 1 - u;
             }
             uv = new Vector(u,v,0); 
          } //<>//
          if (m.NormalMap != null) {
            int w = m.NormalMap.width;
            int h = m.NormalMap.height; 
            Vector normalColor = new Vector(m.NormalMap.get((int) (uv.x*w), (int) (uv.y*h)));
            float x = 2*normalColor.r - 1;
            float y = 2*normalColor.g - 1;
            float z = 2*normalColor.b - 1;
            Vector mapNormal = new Vector(x,y,z);
            mapNormal.Normalize();
            Nh = Nh.Add(mapNormal);
            Nh.Normalize();
          }
          
        hit = new Hit(Ph, Nh, m, num, uv);
     }
      
    return hit;
  }
}

public class InfiniteSphere extends Shape {
  Vector Pi;
  Material m;
  
  public InfiniteSphere(Material m, int n) {
    this.Pi = Pe;
    this.m = m;
    num = n;
  }
  
  public Hit findHit(Ray ray) {
    Vector o = ray.origin; //<>//
    Vector n = ray.getDir(); //Get unit vector version of ray (Npe)
    Hit hit = null;
    
    float Th = 1000;
    Vector Ph = n.Mult(Th).Add(o); //Npe*Th + Pe
    Vector Nh = Ph.Sub(Pi).Div(1000); //(Ph - Pi)/r
    Nh.Normalize();
        
    Vector uv = new Vector(0,0,0);
    if (m.isProjectionTexture) {
      uv = new Vector(currentU, currentV, 0);
      println(currentU + ' '+ currentV);
    } else {
      Vector N1 = new Vector(1, 0, 0);
      Vector N0 = new Vector(0, 0, 1);
      Vector N2 = new Vector(0, -1, 0);
      //Calculate Texture UV
      float v = acos(N2.Dot(Ph.Sub(Pi))/1000)/((float)Math.PI);
      float u = acos((N1.Dot(Ph.Sub(Pi))/1000)/sin((float)Math.PI * v))/((float)Math.PI * 2);
      if (N0.Dot(Ph.Sub(P00))/1000 < 0) {
         u = 1 - u;
       }
       uv = new Vector(u,v,0); 
    }
          
      hit = new Hit(Ph, Nh, m, num, uv);
      
    return hit;
  }
}

public class Plane extends Shape{
  Vector Pi;
  Vector Ni;
  Material m;
  
  public Plane(Vector Pi, Material m, Vector Ni, int n) {
    this.Pi = Pi;
    this.Ni = Ni;
    this.Ni.Normalize();
    this.m = m;
    num = n;
  }
  
  public Hit findHit(Ray ray) {
    Vector o = ray.origin;
    Vector n = ray.getDir();
    Hit hit = null;
    
    if (Ni.Dot(n) < 0) {
      float Th = Ni.Mult(-1).Dot(o.Sub(Pi))/(Ni.Dot(n)); //(-Ni DOT (Pe - Pi))/Ni Dot Npe
      Vector Ph = n.Mult(Th).Add(o);
      Vector Nh = Ni;
      
      //Calculate Texture UV
       Vector N1 = new Vector(1, 0, 0);
       Vector N0 = new Vector(0, 0, 1);
       Vector N2 = new Vector(0, -1, 0);
      float u = N0.Dot(Ph.Sub(Pi))/m.tileSize;
      float v = N1.Dot(Ph.Sub(Pi))/m.tileSize;
      if (u > 1) {
        u = u % 1; 
      } else if ( u < 0) {
        float mod1 = u % 1;
        u = 1 + mod1;
      }   
      if (v > 1) {
        v = v % 1; 
      } else if ( v < 0) {
        float mod1 = v % 1;
        v = 1 + mod1;
      }
     Vector uv = new Vector(u,v,0);
     
     if (m.NormalMap != null) {
            int w = m.NormalMap.width;
            int h = m.NormalMap.height; 
            Vector normalColor = new Vector(m.NormalMap.get((int) (uv.x*w), (int) (uv.y*h)));
            float x = 2*normalColor.r - 1;
            float y = 2*normalColor.g - 1;
            float z = 2*normalColor.b - 1;
            Vector mapNormal = new Vector(x,y,z);
            mapNormal.Normalize();
            Nh = Nh.Add(mapNormal);
            Nh.Normalize();
     }
          
      hit = new Hit(Ph, Nh, m, num, uv);
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
      
  public Triangle(Vector P0, Vector P1, Vector P2, Material m, int n) {
    num = n;
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
  
  public Hit findHit(Ray ray) {
    Vector o = ray.origin;
    Vector n = ray.getDir();
    Hit hit = null;
    
    i++;
    if (Ni.Dot(n) < 0) {
      float Th = Ni.Mult(-1).Dot(o.Sub(P0))/(Ni.Dot(n));
      Vector Ph = n.Mult(Th).Add(o);
      Vector Nh = Ni;
      
      Vector h0 = P0.Sub(Ph);
      Vector h1 = P1.Sub(Ph);
      Vector h2 = P2.Sub(Ph);
      
      float A01 = 0.5*h0.Cross(h1).Mag();
      float A12 = 0.5*h1.Cross(h2).Mag();
      float A20 = 0.5*h2.Cross(h0).Mag();
      float newA = (int)((A01 + A12 + A20)*100)/100.0f;

      if (A >= newA) {
        hit = new Hit(Ph, Nh, m, num, this); 
      }
    }
    return hit;
  }
}

public class Square extends Shape {
  Triangle t1;
  Triangle t2;
      
  public Square(Vector Pi, Vector n0, Vector n1, float s0, float s1, Material m, int n) {
    num = n;
    n0.Normalize();
    n1.Normalize();
    Vector P0 = Pi.Sub(n0.Mult(s0/2)).Sub(n1.Mult(s1/2));
    Vector P1 = P0.Add(n1.Mult(s1));
    Vector P2 = P0.Add(n0.Mult(s0));
    Vector P3 = P1.Add(n0.Mult(s0));
    t1 = new Triangle(P1,P2,P0,m, n);
    t2 = new Triangle(P1,P2,P3,m, n);
  }
  
   public Hit findHit(Ray ray) {
    Hit hit = t1.findHit(ray);
    if (hit == null) {
      hit = t2.findHit(ray); 
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
  
  
  public Quadric(int A02, int A12, int A22, int A21, int A00, float S0, float S1, float S2, Vector View2, Vector Up, Vector Pc, Material m, int n) {
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
    
    num = n;
    
    println(n0 + " " + n1 + " " + n2);
    this.m = m;
  }
  
  public Hit findHit(Ray ray) {
    Vector o = ray.origin;
    Vector n = ray.getDir();
    Hit hit = null;
    
    float eyeCheck = 0;
    eyeCheck += sumFunct(a02, o, n0, s0, 2);
    eyeCheck += sumFunct(a12, o, n1, s1, 2);
    eyeCheck += sumFunct(a22, o, n2, s2, 2);
    eyeCheck += sumFunct(a21, o, n2, s2, 1);
    eyeCheck += a00;
    
    //println(eyeCheck);
    if (eyeCheck >= 0) {
      float A = a02*pow(n0.Dot(n)/s0, 2) + a12*pow(n1.Dot(n)/s1, 2) + a22*pow(n2.Dot(n)/s2, 2);
      float B = a02*(2*n0.Dot(n)*n0.Dot(o.Sub(Pi))/s0*s0) + a12*(2*n1.Dot(n)*n1.Dot(o.Sub(Pi))/s1*s1) + a22*(2*n2.Dot(n)*n2.Dot(o.Sub(Pi))/s2*s2) + a21*(n2.Dot(n)/s2);
      float C = a02*pow(n0.Dot(o.Sub(Pi))/s0,2) + a12*pow(n1.Dot(o.Sub(Pi))/s1,2) + a22*pow(n2.Dot(o.Sub(Pi))/s2,2) + a21*n2.Dot(o.Sub(Pi))/s2 + a00;
      
      float checkNum1 = 2*A;
      float checkNum2 = B*B - 4*A*C;
      
     // println(checkNum1 + " " + checkNum2);
      if (checkNum1 != 0 && checkNum2 >= 0) {        
        float t1 = (-1 * B + sqrt(B*B - 4*A*C))/2*A;
        float t2 = (-1 * B - sqrt(B*B - 4*A*C))/2*A; 
        //println (t1 + " " + t2);
        if (t1 > 0 && t2 >0) {
          float th = min(t1,t2);
          Vector Ph = o.Add(n.Mult(th));
          Vector Nh = n0.Mult(2*a02*(n0.Dot(Ph.Sub(Pi))/s0*s0)).Add(n1.Mult(2*a12*(n1.Dot(Ph.Sub(Pi))/s1*s1))).Add(n2.Mult(2*a22*(n2.Dot(Ph.Sub(Pi))/s2*s2))).Add(n2.Mult(a21/s2));
          Nh.Normalize();
          hit = new Hit(Ph, Nh, m, num, this);
          //println(Ph.toString() + " " + Nh.toString());
        }
      }
    }
    
    return hit;
  }
  
  private float sumFunct(float a, Vector P, Vector n, float s, float power) {
    return a*pow((n.Dot(P.Sub(Pi)))/s, power);
  }
}
