/*
* Cassie Mullins
* VIZA 656
* Homweork 10
* 
* Press 1 - Select one of the provided scenes files to render. Rendered images are saved in the renders folder.
* 
* Animator has been further implemented to animate the camera, lights, shapes, and materials. Things can be transformed and individual properties can be changed.
* The image painting technique has also been implemented and can be used with or without animation.
* Final Renderes of the animations are provided already put together as videos.
*/


Vector Pe;
Vector n0;
Vector n1;
Vector n2;
Vector P00;
float s0;
float s1;
 Vector Vview;
 Vector Vup;
 float lensSize = 0.001f;
 float lensAliasSize = 1;
 float d = 1;

boolean enteringPlane = true;
boolean generateNormalMap = false;
boolean isStereo = false;

float currentU;
float currentV;

Vector background = new Vector(0,0,0);

Shape[] shapeList;
Light[] lightList;
Material[] matList;

String name = "";

boolean isAnimation = false;
int frames = 0;

Animator animator;

int lightNum;
int shapeNum;
int materialNum;

ArrayList<color[][]> motionBlurColors = new ArrayList<color[][]>();
int motionBlurFrames = 1;

PImage paintEffectImg;
float A,B,C;
boolean isPaintEffectAnimated;
String paintEffectName;

void setup() {
  size(800,450);  
  background(0);
  colorMode(RGB, 1.0);
  animator = new Animator();
  
  Vector p00 = new Vector(9.000,19.000,9.000);
  Vector n0 = new Vector(0.000,0.868,-0.496);
  Vector n1 = new Vector(0.896,-0.221,-0.386);
  float s0 = 16;
  float s1 = 9;
  float m = 5;
  float n = 5;
  float M = 17;
  float N = 21;
  float r0 = 0.49;
  float r1 = 0.75;
  
  Vector P10 = p00.Add(n0.Mult(s0));
  Vector P01 = p00.Add(n1.Mult(s1));
  Vector P11 = p00.Add(n0.Mult(s0)).Add(n1.Mult(s1));
  Vector PL = p00.Add(n0.Mult(((m+r0)/M)*s0)).Add(n1.Mult(((n+r1)/N)*s1));
  println(P10.toString());
  println(P01.toString());
  println(P11.toString());
  println(PL.toString());

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
  motionBlurColors = new ArrayList<color[][]>();
  if (isAnimation) {
     for (int i = 100; i < frames; i++) {
       println("Rendering Frame: " + i);
       renderFrame(i); 
       animator.animate(i);
     }
  } else {
    renderFrame(null); 
  }
}

void renderFrame(Integer frameNum) {
  if (isPaintEffectAnimated) {
    paintEffectImg = loadImage("Textures\\" + paintEffectName + "\\0" + (frameNum < 100 ? frameNum < 10 ? "00" : "0" : "") + frameNum + ".png");
  }
  int stereoNum = isStereo ? 2 : 1;
  for (int c = 0; c < stereoNum; c++) {
    ArrayList<color[][]> images = new ArrayList<color[][]>();
    float aliasSize = 4;
    Vector startPe = Pe;
    
    float lensASize = lensSize/lensAliasSize;
    for (int a = 0; a < lensAliasSize; a++) {
      for (int b = 0; b < lensAliasSize; b++) {
        float newA = lensAliasSize > 1 ? a + random(0,1): a;
        float newB = lensAliasSize > 1 ? b + random(0,1) : b;
        Pe = startPe.Add(new Vector(newA*lensASize, newB*lensASize, 0));
        float stereoVal = isStereo ? (c - 0.5)*2 : 0;
        Pe = Pe.Add(new Vector(stereoVal,0,0));
        
        color[][] colors = new color[width][height];
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
                 
                 Vector Npe = P00.Add(n0.Mult(u)).Add(n1.Mult(v)); //Pe + n2*d + n0*i + n1*j
                 if (paintEffectImg != null && u < paintEffectImg.width && v < paintEffectImg.height) {
                   color col = paintEffectImg.get(i, j); //<>// //<>//
                   Npe = Npe.Add(n0.Mult(A*red(col))).Add(n1.Mult(B*green(col))).Add(n2.Mult(C*blue(col)));
                 }
                 Npe.Normalize();
                 Hit hit = null;
                 
                 Ray ray = new Ray(Pe, Npe.Add(Pe));
                 //println(u + " " + v + " " + ray.origin.toString() + " " + ray.getDir().toString());
                 hit = findHit(ray);
                 //println(finalColor.toString());
                 finalColor = finalColor.Add(getColor(hit, 0, Pe).Mult(1/(aliasSize*aliasSize)));
              }
            }
            
           
           colors[i][j] = color(finalColor.x, finalColor.y, finalColor.z);
           if (!isAnimation) {
             set(i,j,color(finalColor.x, finalColor.y, finalColor.z)); 
           }
          }
        }
        images.add(colors);
      }
    }
    color[][] motionBlurColor = new color[width][height];
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        float weight = 1.0/images.size();
        float r = 0;
        float g = 0;
        float b = 0;
        for (color[][] colList : images) {
          Vector currentColor = new Vector(colList[i][j]);
          currentColor = currentColor.Mult(weight);
          r += currentColor.r;
          g += currentColor.g;
          b += currentColor.b;
        }
        //set(i,j,color(r, g, b));
        motionBlurColor[i][j] = color(r,g,b);
      }
    }
    
    motionBlurColors.add(motionBlurColor);
    if (motionBlurColors.size() >0) {
       for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
          float weight = 1.0/motionBlurColors.size();
          float r = 0;
          float g = 0;
          float b = 0;
          for (color[][] colList : motionBlurColors) {
            Vector currentColor = new Vector(colList[i][j]);
            currentColor = currentColor.Mult(weight);
            r += currentColor.r;
            g += currentColor.g;
            b += currentColor.b;
          }
          set(i,j,color(r, g, b));
        }
      }
      if (motionBlurColors.size() == motionBlurFrames) {
          motionBlurColors.remove(0); 
      }
    }
    String stereo = isStereo ? "Stereo" + c : "";
    String end = frameNum == null ? ".png" : (int)frameNum + ".png";
    Pe = startPe;
    save("Renders//" + name + stereo + "Render" + (generateNormalMap ? "Normal" + end : end));
  }
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
    Crefr = getTransmission(hit, depth, E);
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
    float value = smoothstep(0,1,Krefl+Krefr);
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
  
  float range = hit.m.drtRange;
  float alias = range == 0 ? 1 : 3;
  float weight = 1/alias;
  for (int i = 0; i < alias; i++) {
    float theta = Nh.Dot(I);
    theta = theta + random(radians(range)) - radians(range/2);
    Vector R = Nh.Mult(2*theta).Sub(I); //Eye Reflection Vector
    Ray ray = new Ray(hit.p, R.Add(hit.p));
    Hit newHit = hit.m.envMap != null ? hit.m.envMap.findHit(ray) : findHit(ray);
    if (newHit != null) {
      if (i == 0) {
         Crefl = new Vector(0,0,0);
      }
      Vector newCrefl = getColor(newHit, depth + 1, hit.p);
      newCrefl = newCrefl.Mult(weight);
      Crefl = Crefl.Add(newCrefl);
    }  
  }
  return Crefl;
}

Vector getTransmission(Hit hit, int depth, Vector I) {
  Vector Crefr = new Vector(1,1,1);
 
  float range = hit.m.drtRange;
  float alias = range == 0 ? 1 : 3;
  float weight = 1/alias;
  for (int i = 0; i < alias; i++) {
    float nr = hit.isEntering ? 1/hit.getN() : hit.getN();
    nr += random(radians(range)) - radians(range);
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
      if (i == 0) {
         Crefr = new Vector(0,0,0);
      }
      Vector newCrefr = getColor(newHit, depth + 1, hit.p);
      newCrefr = newCrefr.Mult(weight);
      Crefr = Crefr.Add(newCrefr);
      //println("New refrac Color: " + Crefr.toString());
    }
  }
  return Crefr;
}

float smoothstep(float min, float max, float x) {
  x = constrain((x-min)/(max-min), 0, 1);
  return x * x * (3 - 2*x);
}
