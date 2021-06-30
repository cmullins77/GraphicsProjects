/*
* Cassie Mullins
* VIZA 656
* Homweork 6
* 
* Press 1 - Select one of the provided scenes files to render. Rendered images are saved in the renders folder.
* 
* The program can now take in Texture based materials. The textures are stored in the textures folder. A material can either use just a c1 texture or a texture for c0, c1, and cp. 
* Mapping works on spheres, as a tiled wallpaper on planes, and as an environment map
* Texture materials can also be specified to use projection instead of normal uv mapping
* The Texture material can also take in a normal map which can be applied to planes and spheres
* Each of these capabilities can be checked using the scene text files.
*/


Vector Pe;
Vector n0;
Vector n1;
Vector n2;
Vector P00;
float s0;
float s1;

float currentU;
float currentV;

Vector background = new Vector(0,0,0);

Shape[] shapeList;
Light[] lightList;

String name = "";

void setup() {
  size(500,500);  
  background(0);
  colorMode(RGB, 1.0);
}

void draw() {
  
}



void keyPressed() {
  if (key == '1') {
    selectInput("Select a scene file:", "readFromFile");
  }
}

void render() {
  float aliasSize = 4;
  
  float scaledHeight = height/s1;
  float scaledWidth = width/s0;
  println("Rendering");
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      
      Vector finalColor = new Vector(0,0,0);
      
      for (float m = 0; m < 1; m = m + 1/aliasSize) {
        for (float n = 0; n < 1; n = n + 1/aliasSize) {
          float rand = random(0, 1/aliasSize);
          float newi = i + m + rand;
          float newj = j + n + rand;
                 
           float u = newi/scaledWidth;
           float v = newj/scaledHeight;
           currentU = u;
           currentV = v;
           
           Vector Npe = P00.Add(n0.Mult(u)).Add(n1.Mult(v));
           Npe.Normalize();
           Hit hit = null;
           
           Ray ray = new Ray(Pe, Npe.Add(Pe));
            for (int k = 0; k < shapeList.length; k++) {
              Shape shape = shapeList[k];
              Hit newHit = shape.findHit(ray);
              if (hit == null) {
                hit = newHit; 
              } else if (newHit != null) {
                if (newHit.p.Dist(Pe) < hit.p.Dist(Pe)) {
                  hit = newHit; 
                }
              }
            }
           finalColor = finalColor.Add(getColor(hit).Mult(1/(aliasSize*aliasSize)));
        }
      }
      
     
     
      set(i,j,color(finalColor.x, finalColor.y, finalColor.z));
    }
  }
}

Vector getColor(Hit hit) {
  if (hit == null) {
    return background; 
  }
  Vector Ph = hit.p;
  Vector Nh = hit.n;
  
  Vector finalCol = new Vector(0,0,0);
  for (int i = 0; i < lightList.length; i++) {
    Light light = lightList[i];
          
    Vector I = Pe.Sub(Ph);
    I.Normalize();
    
    Vector borderC = hit.m.borderColor;
    
    if (I.Dot(Nh) < cos(radians(90 - hit.m.thickness)) && borderC != null) {
      return borderC;
    } else {
      finalCol = finalCol.Add(light.calculateColor(hit)); 
    }
  }
  return finalCol;
}

Vector calculateColorFromLight(Vector L, Vector Cl, Hit hit, boolean shadow) {
   if (hit == null) {
    return background; 
  }
  Vector Ph = hit.p;
  Vector Nh = hit.n;
  
  Vector finalCol = new Vector(0,0,0);
          
 float t = Nh.Dot(L);
  t = shadow ? 0 : smoothstep(0,1,t);
  //println(t);
          
  Vector R = Nh.Mult(2*Nh.Dot(L)).Sub(L);
  Vector I = Pe.Sub(Ph);
  I.Normalize();
    
  float S = I.Dot(R);
  S = smoothstep(0,1,S);
  S = shadow ? 0 : pow(S,hit.m.P);
           
  Vector c0 = hit.getC0();
  Vector c1 = hit.getC1();
  Vector cP = hit.getCP();
  float cR = (c0.r*(1-Cl.r*t) + c1.r*Cl.r*t)*(1-hit.m.Ks*S) + hit.m.Ks*S*cP.r*Cl.r;
  float cG = (c0.g*(1-Cl.g*t) + c1.g*Cl.g*t)*(1-hit.m.Ks*S) + hit.m.Ks*S*cP.g*Cl.g;
  float cB = (c0.b*(1-Cl.b*t) + c1.b*Cl.b*t)*(1-hit.m.Ks*S) + hit.m.Ks*S*cP.b*Cl.b; 
  Vector newCol = new Vector(cR, cG, cB);
  finalCol = finalCol.Add(newCol); 
    
  return finalCol;
}

boolean getShadow(Light light, Vector P, int num, float maxDistance) {
  for (int k = 0; k < shapeList.length; k++) {
     Shape shape = shapeList[k];
     if (shape.num != num) {
       Ray ray = new Ray(P, light.getShadowVec(P));
       Hit newHit = shape.findHit(ray); 
       if (newHit != null) {
         float dist = P.Dist(newHit.p);
         if (maxDistance < 0 || dist <= maxDistance) {
            return true;  
         }
       }
     }
  }
  return false;  
}

float smoothstep(float min, float max, float x) {
  x = constrain((x-min)/(max-min), 0, 1);
  return x * x * (3 - 2*x);
}
