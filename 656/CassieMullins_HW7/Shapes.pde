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
  
  Vector VT0, VT1, VT2;
  Vector VN0, VN1, VN2;
  
   int i = 0;
   
   float A;
   
   boolean objTriangle;
      
  public Triangle(Vector P0, Vector P1, Vector P2, Material m, int n) {
    num = n;
    this.P0 = P0;
    this.P1 = P1;
    this.P2 = P2;
    
    
    Vector E1 = P1.Sub(P0);
    Vector E2 = P2.Sub(P0);
    Ni = E1.Cross(E2);
    Ni.Normalize();
    
    A = (((P1.Sub(P0)).Cross(P2.Sub(P1))).Div(2)).Mag();
    
    this.m = m;
    objTriangle = false;
    VT0 = new Vector(0,0,0);
    VT1 = new Vector(0,0,0);
    VT2 = new Vector(0,0,0);
    VN0 = Ni;
    VN1 = Ni;
    VN2 = Ni;
  }
  
  public Hit findHit(Ray ray) {
    Vector o = ray.origin;
    Vector n = ray.getDir();
    Hit hit = null;
    if (Ni.Add(P0).Dist(o) > Ni.Mult(-1).Add(P0).Dist(o)) {
      Ni = Ni.Mult(-1); 
    }
    i++;
    if (Ni.Dot(n) < 0) {
      float Th = Ni.Mult(-1).Dot(o.Sub(P0))/(Ni.Dot(n)); //(-Ni DOT (Pe - Pi))/Ni Dot Npe
      Vector Ph = n.Mult(Th).Add(o);
      Vector Nh = Ni;
      
      Vector A0 = (Ph.Sub(P2).Cross(P1.Sub(Ph)).Div(2));
      Vector A1 = (Ph.Sub(P0).Cross(P2.Sub(Ph)).Div(2));
      Vector A2 = (Ph.Sub(P1).Cross(P0.Sub(Ph)).Div(2));
      Vector N = A0.Div(A0.Mag());
      
      float s = N.Dot(A0)/A;
      float t = N.Dot(A1)/A;
      float st = N.Dot(A2)/A;
      if (s >= 0 && t >= 0 && st >= 0 && s <= 1 && t <= 1 && st <= 1) {
        float uh = st*VT0.x + s*VT1.x + t*VT2.x;
        float vh = st*VT0.y + s*VT1.y + t*VT2.y;
        Vector uv = new Vector(uh, vh, 0);
        if (m.isSmoothShading) {
          Vector Vh = VN0.Mult(st).Add(VN1.Mult(s)).Add(VN2.Mult(t));
          Vh.Normalize();
          Nh = Vh;
        }
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
          Nh.Normalize(); //<>//
      }
      hit = new Hit(Ph, Nh, m, num, uv); 
      }
    }
    return hit;
  }
}

public class Model extends Shape {
    Vector P;
    Material m;
    ArrayList<Vector> vertices;
    ArrayList<Vector> vt;
    ArrayList<Triangle> faces;  
    
    public Hit findHit(Ray ray) {
      Hit hit = null;
      for (Triangle t : faces) {
        Hit newHit = t.findHit(ray);
        if (hit == null) {
          hit = newHit;
        } else if (newHit != null && newHit.p.Dist(ray.origin) < hit.p.Dist(ray.origin)) {
        //<>//
          hit = newHit;
        }
      }
     
      return hit;
    }
}

public class Cube extends Model {
  public Cube (Vector P, Vector S, Material m, int n) {
    this.m = m;
    this.num = n;
    float front = P.z - S.z/2;
    float back = P.z + S.z/2;
    float left = P.x - S.x/2;
    float right = P.x + S.x/2;
    float top = P.y - S.y/2;
    float bottom = P.y + S.y/2;
    Vector p0 = new Vector(left, top, front);
    Vector p1 = new Vector(left, bottom, front);
    Vector p2 = new Vector(right, top, front);
    Vector p3 = new Vector(right, bottom, front);
    Vector p4 = new Vector(left, top, back);
    Vector p5 = new Vector(left, bottom, back);
    Vector p6 = new Vector(right, top, back);
    Vector p7 = new Vector(right, bottom, back);
    
    faces = new ArrayList<Triangle>();
    faces.add(new Triangle(p0, p2, p3, m, n));
    faces.add(new Triangle(p0, p1, p3, m, n));
    faces.add(new Triangle(p0, p2, p4, m, n));
    faces.add(new Triangle(p2, p4, p6, m, n));
    faces.add(new Triangle(p4, p6, p7, m, n));
    faces.add(new Triangle(p4, p5, p7, m, n));
    faces.add(new Triangle(p1, p3, p5, m, n));
    faces.add(new Triangle(p3, p5, p7, m, n));
    faces.add(new Triangle(p0, p1, p5, m, n));
    faces.add(new Triangle(p0, p4, p5, m, n));
    faces.add(new Triangle(p2, p3, p7, m, n));
    faces.add(new Triangle(p2, p6, p7, m, n));
    
    vt = new ArrayList<Vector>();
  }
}

public class Tetrahedron extends Model {
  public Tetrahedron (Vector P, Vector S, Material m, int n) {
    this.m = m; //<>//
    this.num = n;
    float front = P.z - S.z/2;
    float back = P.z + S.z/2;
    float left = P.x - S.x/2;
    float right = P.x + S.x/2;
    float top = P.y - S.y/2;
    float bottom = P.y + S.y/2;
    Vector p0 = new Vector(left, bottom, front);
    Vector p1 = new Vector(right, top, front);
    Vector p2 = new Vector(left, top, back);
    Vector p3 = new Vector(right, bottom, back);
    
    faces = new ArrayList<Triangle>();
    faces.add(new Triangle(p0, p1, p2, m, n));
    faces.add(new Triangle(p1, p2, p3, m, n));
    faces.add(new Triangle(p0, p1, p3, m, n));
    faces.add(new Triangle(p0, p2, p3, m, n));
    
    vt = new ArrayList<Vector>();
  }
}

public class OBJ extends Model {

  
  public OBJ(Vector P, String fileName, Material m, int n) {
    num = n;  
    this.m = m;
    this.P = P;
    vertices = new ArrayList<Vector>();
    faces = new ArrayList<Triangle>();
    vt = new ArrayList<Vector>();
    readFile(fileName);
  }
  
  void readFile(String name) {
    try {
     BufferedReader reader = new BufferedReader(new FileReader(name));
     String line = reader.readLine();
     
     while (line != null) { //Parse each line in the file in turn
       println(line);
       if (!line.isEmpty()) {
          String[] words = line.split(" "); //split the line into individual tokens
       
           if (words.length <= 1 || words[0].charAt(0) == '#') { //skip empty lines & comments
             println("Do Nothing");
           } else if (words[0].equals("v")) {
             Vector v = new Vector(Float.parseFloat(words[1]), Float.parseFloat(words[2]), Float.parseFloat(words[3]));
             v = v.Add(P);
             println(v.toString());
             vertices.add(v);
           } else if (words[0].equals("vt")) {
             Vector currVT = new Vector(Float.parseFloat(words[1]), Float.parseFloat(words[2]), 0);
             println(vt.toString());
             vt.add(currVT);
           }else if (words[0].equals("f")) {
             String[] currentPoint = words[1].split("/");
             Vector P0 = vertices.get(Integer.parseInt(currentPoint[0]) - 1);
             Vector VT0 = new Vector(0,0,0);
             if (currentPoint.length > 1) {
               VT0 = vt.get(Integer.parseInt(currentPoint[1]) - 1);
             }
             currentPoint = words[2].split("/");
             Vector P1 = vertices.get(Integer.parseInt(currentPoint[0]) - 1);
             Vector VT1 = new Vector(0,0,0);
             if (currentPoint.length > 1) {
               VT1 = vt.get(Integer.parseInt(currentPoint[1]) - 1);
             }
             
             currentPoint = words[3].split("/");
             Vector P2 = vertices.get(Integer.parseInt(currentPoint[0]) - 1);
             Vector VT2 = new Vector(0,0,0);
             if (currentPoint.length > 1) {
               VT2 = vt.get(Integer.parseInt(currentPoint[1]) - 1);
             }
             
             Triangle t = new Triangle(P0, P1, P2, m, num);
             t.VT0 = VT0;
             t.VT1 = VT1;
             t.VT2 = VT2;
             t.objTriangle = true;
             faces.add(t);
           }
        }
        line = reader.readLine();
     }
     println("Close Reader");
     reader.close();
   } catch (Exception e) {
     println(e.toString() + " caught in interpreter");
  }   
  } //<>//
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
