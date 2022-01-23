/*
* Cassie Mullins
* VIZA 656
* Homweork 4
* 
* Press 1 - Select one of the provided scenes files to render. Rendered images are saved in the renders folder.
* 
* The program currently supports spheres, planes, and quadrics. 
* The camera can be moved and rotated and its FOV may be manipulated by changing either the s values or the distance between the camera and the screen
* Materials currently include diffuse colors and specular highlights which can be made sharper or smoother by changing the material's roughness.
* Lights currently included are point, direction, and spotlights
* I also includied bordres as part of the material
*
* Each of these various capabilities are demonstrated in at least one of the scene text files.
*/


Vector Pe;
Vector n0;
Vector n1;
Vector P00;
float s0;
float s1;

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
  float aliasSize = 4; //<>//
  
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
           
           
           Vector Npe = P00.Add(n0.Mult(u)).Add(n1.Mult(v));
           Npe.Normalize();
           Hit hit = null;
            for (int k = 0; k < shapeList.length; k++) {
              Shape shape = shapeList[k];
              Hit newHit = shape.findHit(Npe);
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
  
  if (hit.m.C1.r == 1 && Nh.z > 0) {
    //println("HIT");  //<>//
  }
  
  Vector finalCol = new Vector(0,0,0);
  for (int i = 0; i < lightList.length; i++) {
    Light light = lightList[i];
    Vector L = light.getLightVector(Ph);
    Vector Cl = light.Cl;
          
    float t = Nh.Dot(L);
    t = smoothstep(0,1,t);
          
    Vector R = Nh.Mult(2*Nh.Dot(L)).Sub(L);
    Vector I = Pe.Sub(Ph);
    I.Normalize();
    
    Vector borderC = hit.m.borderColor;
    
    if (I.Dot(Nh) < cos(radians(90 - hit.m.thickness)) && borderC != null) {
      return borderC;
    } else {
      float S = I.Dot(R);
      S = smoothstep(0,1,S);
      S = pow(S,hit.m.P);
            
      float cR = (hit.m.C0.r*(1-Cl.r*t) + hit.m.C1.r*Cl.r*t)*(1-hit.m.Ks*S) + hit.m.Ks*S*hit.m.Cp.r*Cl.r;
      float cG = (hit.m.C0.g*(1-Cl.g*t) + hit.m.C1.g*Cl.g*t)*(1-hit.m.Ks*S) + hit.m.Ks*S*hit.m.Cp.g*Cl.g;
      float cB = (hit.m.C0.b*(1-Cl.b*t) + hit.m.C1.b*Cl.b*t)*(1-hit.m.Ks*S) + hit.m.Ks*S*hit.m.Cp.b*Cl.b; 
      Vector newCol = new Vector(cR, cG, cB);
      finalCol = finalCol.Add(newCol); 
    }
  }
  return finalCol;
}

float smoothstep(float min, float max, float x) {
  x = constrain((x-min)/(max-min), 0, 1);
  return x * x * (3 - 2*x);
}
