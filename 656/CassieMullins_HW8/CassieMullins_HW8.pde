/*
* Cassie Mullins
* VIZA 656
* Homweork 8
* 
* Press 1 - Select one of the provided scenes files to render. Rendered images are saved in the renders folder.
* 
* Program now supports Reflection & Refraction
* Both work on Spheres, Planes, and Polygonal Meshes
* I've also included environment map reflections, reflection and refraction using normal maps, and the index of refraction can be modified using a texture
* There are examples of each provided in the scenes folder
*/


Vector Pe;
Vector n0;
Vector n1;
Vector n2;
Vector P00;
float s0;
float s1;

boolean enteringPlane = true;
boolean generateNormalMap = false;

float currentU;
float currentV;

Vector background = new Vector(0,0,0);

Shape[] shapeList;
Light[] lightList;

String name = "";

boolean isAnimation = false;

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
  } else if (key == '2') {
    generateNormalMap = !generateNormalMap; 
  }
}

void render() {
  if (isAnimation) {
     
  } else {
    renderFrame(null); 
  }
}

void renderFrame(Integer frameNum) {
   float aliasSize = 4;
  
  float scaledHeight = height/s1;
  float scaledWidth = width/s0;
  //println("Rendering");
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
           //println(u + " " + v + " " + ray.origin.toString() + " " + ray.getDir().toString());
           hit = findHit(ray);
           //println(finalColor.toString());
           finalColor = finalColor.Add(getColor(hit, 0, Pe).Mult(1/(aliasSize*aliasSize)));
        }
      }
      
     
     
      set(i,j,color(finalColor.x, finalColor.y, finalColor.z));
    }
  }
  String end = frameNum == null ? ".png" : (int)frameNum + ".png";
  save("Renders//" + name + "Render" + (generateNormalMap ? "Normal" + end : end));
}

Hit findHit(Ray ray) {
  Hit hit = null;
  for (int k = 0; k < shapeList.length; k++) {
      Shape shape = shapeList[k];
      //println(shape.toString());
      Hit newHit = shape.findHit(ray);
      if (hit == null) {
         hit = newHit; 
       } else if (newHit != null) {
          if (newHit.p.Dist(ray.origin) < hit.p.Dist(ray.origin)) {
            //println("Hit is Closer");
             hit = newHit; 
           }
        }
    }
    return hit;
}

Vector getColor(Hit hit, int depth, Vector origin) {
  if (generateNormalMap) {
    Vector normal = new Vector(0,0,1);
    if (hit != null) {
       normal = hit.n;
    }
    float r = (normal.x + 1)/2;
    float g = (normal.y*-1 + 1)/2;
    float b = (normal.z + 1)/2;
    Vector col = new Vector(r,g,b);
    col.Normalize();
    return col;
  }
  if (hit == null) {
    //println("Background");
    return background; 
  }
  Vector Ph = hit.p;
  Vector Nh = hit.n;
  
  Vector I = origin.Sub(Ph);
  I.Normalize();
  
  //println(Ph.toString() + " " + Nh.toString() + " " + I.toString());
  
  Vector finalCol = new Vector(0,0,0);//hit.getC0();
  for (int i = 0; i < lightList.length; i++) {
    Light light = lightList[i];
    
    Vector borderC = hit.m.borderColor;
    
    if (I.Dot(Nh) < cos(radians(90 - hit.m.thickness)) && borderC != null) {
      return borderC;
    } else {
      //println("Calculate Color from Light");
      finalCol = finalCol.Add(light.calculateColor(hit, depth)); 
    }
  }
  //float Krefl = hit.m.Krefl;
  //if (Krefl > 0 && depth < 10) {
  //  //println("Reflection!");
  //  Vector Crefl = getReflection(hit, depth, I).Mult(Krefl);
  //  finalCol = finalCol.Mult(1-Krefl).Add(Crefl);
  //}
  //float Krefr = hit.m.Krefr;
  //if (Krefr > 0 && depth < 5) {
  //  //println("Refraction " + Krefr);
  //  Vector Crefr = getTransmission(hit, depth, I).Mult(Krefr);
  //  finalCol = finalCol.Mult(1-Krefr).Add(Crefr);
  //  //println("Final Col" + finalCol.toString());
  //}
  
  return finalCol;
}

Vector calculateColorFromLight(Vector L, Vector Cl, Hit hit, boolean shadow, int depth) {
   if (hit == null) {
    return background; 
  }
  Vector Ph = hit.p;
  Vector Nh = hit.n;
  
  Vector c0 = hit.getC0();
  Vector c1 = hit.getC1();
  Vector cA = c0;
  Vector cD = c1.Sub(c0);
  Vector cP = hit.getCP();
  
  Vector R = Nh.Mult(2*Nh.Dot(L)).Sub(L); //Light Reflection Vector
  Vector E = Pe.Sub(Ph); //Eye Vector
  E.Normalize();
  
  float Krefl = hit.m.Krefl;
  Vector Crefl = new Vector(0,0,0);
  if (Krefl > 0 && depth < 10) {
    //println("Reflection!");
    Crefl = getReflection(hit, depth, E);
  }
  float Krefr = hit.m.Krefr;
  Vector Crefr = new Vector(0,0,0);
  if (Krefr > 0 && depth < 10) {
    //println("Refraction " + Krefr);
    Crefr = getTransmission(hit, depth, E); //<>//
  }
  
  float S = E.Dot(R);
  S = smoothstep(0,1,S);
  S = shadow ? 0 : pow(S,hit.m.P);
  
  Vector highlightColor = cP.Mult(S).Mult(hit.m.Ks);
  highlightColor = highlightColor.Mult(Cl);
  
  float t = Nh.Dot(L);
  t = shadow ? 0 : smoothstep(0,1,t);
  
  Vector diffuse = cA;
  diffuse = diffuse.Add(Cl.Mult(t).Mult(cD));
  
  if (Krefl > 0 && Krefr > 0 && depth < 10) {
    float value = smoothstep(0,1,Krefl+Krefr); //<>//
    float newKrefr = Krefr/(Krefr + Krefl);
    float newKrefl = Krefl/(Krefr + Krefl);
    diffuse = diffuse.Mult(1-value).Add((Crefl.Mult(newKrefl).Add(Crefr.Mult(newKrefr))).Mult(value)); 
    //diffuse = diffuse.Mult(1-Krefr).Add(Crefr.Mult(Krefr)); 
  } else if (Krefl > 0) {
     diffuse = diffuse.Mult(1-Krefl).Add(Crefl.Mult(Krefl)); 
  } else if (Krefr > 0) {
     diffuse = diffuse.Mult(1-Krefr).Add(Crefr.Mult(Krefr)); 
  }
  diffuse = diffuse.Add(highlightColor);
    
  //println("Diffuse " + diffuse.toString());
  return diffuse;
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

Vector getReflection(Hit hit, int depth, Vector I) {
  Vector Crefl = new Vector(1,1,1);
  Vector Nh = hit.n;
  Vector R = Nh.Mult(2*Nh.Dot(I)).Sub(I); //Eye Reflection Vector
  Ray ray = new Ray(hit.p, R.Add(hit.p));
  Hit newHit = hit.m.envMap != null ? hit.m.envMap.findHit(ray) : findHit(ray);
  if (newHit != null) {
    Crefl = getColor(newHit, depth + 1, hit.p);
  }
  return Crefl;
}

Vector getTransmission(Hit hit, int depth, Vector I) {
  Vector Crefr = new Vector(1,1,1); //<>//
  float nr = hit.isEntering ? 1/hit.getN() : hit.getN();
  Vector N = hit.n;
  Vector T = N.Mult(nr*N.Dot(I) - sqrt(1 - pow(nr,2)*(1 - pow(N.Dot(I), 2)))).Sub(I.Mult(nr));
  
  //println(T.toString() + " " + hit.p.toString());
  
  Vector newP = hit.p.Add(T.Mult(0.001));
  //println("New P: " + newP.toString());
  Ray ray = new Ray(newP, T.Add(newP));
  //println(ray.origin + " " + ray.getDir() + " " + depth);
  Hit newHit = findHit(ray);
 //println("Refr Hits done");
  if (newHit != null) {
    Crefr = getColor(newHit, depth + 1, hit.p);
    //println("New refrac Color: " + Crefr.toString());
  }
  return Crefr;
}

float smoothstep(float min, float max, float x) {
  x = constrain((x-min)/(max-min), 0, 1);
  return x * x * (3 - 2*x);
}
