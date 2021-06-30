/* //<>//
* Cassie Mullins
* VIZA 656
* Homweork 3
* 
* Select one of the Provided Maps which will also select the corresponding dark/light/specular/background/Enviornment images
*
* 1 - Renders a layered image, Go into LayeredScene and one of the versions and layers and select the normal map
* 2 - Renders an Image with Specular & Reflection & Refraction, select the normal map in either Reflection Only or Refraction Only
* 
*/

PImage normalMap;
PImage specularColor;
PImage darkColor;
PImage lightColor;
PImage background;
PImage environmentImage;
PImage reflection;

PImage[] layers;
int currentLayer = 0;

PVector lightPosition = new PVector(-10,8,10);

float saveNum = 1;

public enum Mode {
  DarkLight, Specular
}

Mode mode;

void setup() {
  size(800,800);  
  background(0);
  colorMode(RGB, 1.0);
}

void draw() {
 
}



void keyPressed() {
  if (key == '1') {
      selectInput("Select A Normal Map inside one of the Layered Folders", "selectLayredNormalMap");
   } else if (key == '2') {
       selectInput("Select A Normal Map in one of the Folders", "selectNormalMapSpecular");
   } else if (key == 's') {
     save("Pic" + saveNum + ".jpg");
     saveNum++;
   }
}

void selectLayredNormalMap(File selection) {
  String name = selection.getAbsolutePath();
  println(name);
  name = name.substring(0, name.length() - 9);
  layeredImage(name, 3);
}

void selectNormalMapSpecular(File selection) {
  String name = selection.getAbsolutePath();
  name = name.substring(0, name.length() - 7);
  println(name + "Map.png");
  normalMap = loadImage(name + "Map.png"); 
  darkColor = loadImage(name + "Dark.png");
  lightColor = loadImage(name + "Light.png"); 
  background = loadImage(name + "Background.png");
  specularColor = loadImage(name + "Specular.png");
  reflection = loadImage(name + "Reflection.png");
  environmentImage = loadImage(name + "EnvironmentMap.png");
  drawSpecularShadedImage();
  save(name + "RenderedImage.png");
}

void layeredImage(String name, int num) {
  layers = new PImage[num];
  for(int i = 0; i < num; i++) {
    normalMap = loadImage(name + "\\" + i + "\\Map.png"); 
    darkColor = loadImage(name + "\\" + i + "\\Dark.png");
    lightColor = loadImage(name + "\\" + i + "\\Light.png"); 
    background = i == 0 ? loadImage(name + "Background.png") : layers[i - 1];
    specularColor = loadImage(name + "\\" + i + "\\Specular.png");
    reflection = loadImage(name + "\\" + i + "\\Reflection.png");
    environmentImage = loadImage(name + "EnvironmentMap.png");
    drawSpecularShadedImage();
    PImage savedImage = get(0,0,width,height);
    layers[i] = savedImage;
  }
  save(name + "RenderedImage.png");
}

void drawSpecularShadedImage() {
  PVector light = lightPosition;
  float lLength = sqrt(light.x*light.x + light.y*light.y + light.z*light.z);
  PVector l = new PVector(light.x/lLength, light.y/lLength, light.z/lLength);
 
  for (int i = 0; i < normalMap.width; i++) {
    for (int j = 0; j < normalMap.height; j++) {
      color normalColor = normalMap.get(i,j);
      float red = red(normalColor);
      float green = green(normalColor);
      float blue = blue(normalColor);
      if (red == 0 && green == 0 && blue == 0) {
        set(i, j, background.get(i,j)); 
      } else {
        float x = 2*red - 1;
        float y = 2*green - 1;
        float z = 2*blue - 1;
        float sqrtVal = sqrt(x*x + y*y + z*z);
        x = x/sqrtVal;
        y = y/sqrtVal;
        z = z/sqrtVal;
        PVector n = new PVector(x,y,z);
        
        float t = n.x * l.x + n.y * l.y + n.z * l.z;
        t = smoothstep(0, 1, t);
        
        float s = -l.z + 2*(l.x*n.x*n.z + l.y*n.y*n.z + l.z*n.z*n.z);
        s = smoothstep(0, 1, s);
        
        float ks = red(specularColor.get(i,j));
        
        color c0 = darkColor.get(i,j);
        color c1 = lightColor.get(i,j);
        
        color diffC = color((1 - t)*red(c0) + t*red(c1), (1 - t)*green(c0) + t*green(c1), (1 - t)*blue(c0) + t*blue(c1));
        
        float envD = 5;
        float backD = 3;
        float backH = -3;
        
        float deltaI = 2*envD*n.x*n.z/(2*n.z*n.z-1);
        float deltaJ =  2*envD*n.y*n.z/(2*n.z*n.z-1);
        float envI = i + 2*envD*n.x*n.z/(2*n.z*n.z-1);
        float envJ = j + 2*envD*n.y*n.z/(2*n.z*n.z-1);
        println(deltaI + " " + deltaJ);
        color specC = environmentImage.get((int)envI,(int)envJ);
        float num = 0; //to add specular to reflect-ion and transmitance
        specC = color(max(red(specC), num), max(green(specC), num), max(blue(specC), num));
        
        float backI = i + backD*backH*n.x/(backH*n.z-backH-1);
        float backJ = j + backD*backH*n.y/(backH*n.z-backH-1);
        color transmitC = background.get((int)backI,(int)backJ);
        transmitC = color(max(red(transmitC), num), max(green(transmitC), num), max(blue(transmitC), num));
        
        float transparent = 1 - alpha(c1);
        float reflectiveness = red(reflection.get(i,j));
        
        float r = red(diffC);
        float g = green(diffC);
        float b = blue(diffC);
        
        if (transparent == 0 && reflectiveness == 0) {
          r = r * (1-ks*s) + ks*s;
          g = g * (1-ks*s) + ks*s;
          b = b * (1-ks*s) + ks*s;
        } else {
          float avg = (transparent + reflectiveness)/2;
          transparent = transparent/avg;
          reflectiveness = reflectiveness/avg;
          r = r * (1-ks*s) + ks*s;
          g = g * (1-ks*s) + ks*s;
          b = b * (1-ks*s) + ks*s;
          r = r * (1-avg) + avg*(reflectiveness*red(specC) + transparent*red(transmitC));
          g = g * (1-avg) + avg*(reflectiveness*green(specC) + transparent*green(transmitC));
          b = b * (1-avg) + avg*(reflectiveness*blue(specC) + transparent*blue(transmitC)); 
        }
        
        color newColor = color(r,g,b);

        set(i,j,newColor); 
        
      }
    }
  }
}

float smoothstep(float min, float max, float x) {
  x = constrain((x-min)/(max-min), 0, 1);
  return x * x * (3 - 2*x);
}
