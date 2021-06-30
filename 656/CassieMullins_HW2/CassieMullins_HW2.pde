/* //<>//
* Cassie Mullins
* VIZA 656
* 
* Select one of the Provided Maps which will also select the corresponding dark/light/specular/background/Enviornment images
*
* 1 - Renders a layered image, Go into LayeredScene and one of the versions and layers and select the normal map
* 2 - Renders an Image with Specular & Reflection, select the normal map in either Mirror1 or Mirror2
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

PVector lightPosition = new PVector(0, 0, -1);

float saveNum = 1;

public enum Mode {
  DarkLight, Specular
}

Mode mode;

void setup() {
  size(378,299);
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
        float a = 2*red - 1;
        float b = 2*green - 1;
        float c = 2*blue - 1;
        float sqrtVal = sqrt(a*a + b*b + c*c);
        a = a/sqrtVal;
        b = b/sqrtVal;
        c = c/sqrtVal;
        PVector n = new PVector(a,b,c);
        
        float dotProd = n.x * l.x + n.y * l.y + n.z * l.z;
        
        PVector R = new PVector(2*dotProd*n.x - l.x, 2*dotProd*n.y - l.y, 2*dotProd*n.z - l.z);
        float S = pow(R.z, 10);
        
        float T = 0.5*dotProd + 0.5;
        color c0 = darkColor.get(i,j);
        color c1 = lightColor.get(i,j);
        float newR = red(c0)*(1-T) + red(c1)*T;
        float newG = green(c0)*(1-T) + green(c1)*T;
        float newB = blue(c0)*(1-T) + blue(c1)*T;
        
        color cP = specularColor.get(i,j);
        newR = newR + red(cP)*max(0, S);
        newG = newG + green(cP)*max(0, S);
        newB = newB + blue(cP)*max(0, S);
        
        float D = 3;
        float h = -3;
        float newI = i + D*h*n.x/(h*n.z-h-1);
        float newJ = j + D*h*n.y/(h*n.z-h-1);
        color refractColor = background.get((int)newI,(int)newJ);
        
        D = 3;
        float Krefl = red(reflection.get(i,j));
        newI = i + 2*D*n.x*n.z/(2*n.z*n.z-1);
        newJ = j + 2*D*n.y*n.z/(2*n.z*n.z-1);
        color reflColor = environmentImage.get((int)newI,(int)newJ);
        
        //color newColor = color(red(reflColor)*Krefl + newR*(1-Krefl), green(reflColor)*Krefl + newG*(1-Krefl), blue(reflColor)*Krefl + newB*(1-Krefl));
        float Krefrac = 1 - alpha(c1);
        color newColor = color(red(refractColor)*Krefrac + newR*(1-Krefrac), green(refractColor)*Krefrac + newG*(1-Krefrac), blue(refractColor)*Krefrac + newB*(1-Krefrac));
        newColor = color(red(reflColor)*Krefl + red(newColor)*(1-Krefl), green(reflColor)*Krefl + green(newColor)*(1-Krefl), blue(reflColor)*Krefl + blue(newColor)*(1-Krefl));
        
        set(i,j,newColor); 
        
      }
    }
  }
}
