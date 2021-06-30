/* //<>//
* Cassie Mullins
* VIZA 656
* 
* Select one of the Provided Maps which will also select the corresponding dark/light/specular/background images
*
* 1 - Diffuse, 2 - Specular
* 
*/

PImage normalMap;
PImage specularColor;
PImage darkColor;
PImage lightColor;
PImage background;

PVector lightPosition = new PVector(5,4,10);

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
      selectInput("Select A Normal Map", "selectNormalMapDarkLight");
   } else if (key == '2') {
       selectInput("Select A Normal Map", "selectNormalMapSpecular");
   } else if (key == 's') {
     save("Pic" + saveNum + ".jpg");
     saveNum++;
   }
}

void fixNormalMap(File selection) {
  PImage map = loadImage(selection.getAbsolutePath());
  for (int x = 0; x < map.width; x++) {
     for (int y = 0; y < map.height; y++) {
       color currCol = map.get(x,y);
       float total = red(currCol) + green(currCol) + blue(currCol);
       if (total != 0) {
         currCol = color(red(currCol)/total, green(currCol)/total, blue(currCol)/total); 
       }
       map.set(x,y,currCol);
     }
  }
  map.save("FixedMap.png");
}

void selectNormalMapDarkLight(File selection) {
  String name = selection.getName();
  name = name.substring(0,name.length() - 8);
  println(name);
  normalMap = loadImage(name + "-Map.png"); 
  darkColor = loadImage(name + "-Dark.png");
  lightColor = loadImage(name + "-Light.png"); 
  background = loadImage(name + "-Background.png");
  drawDarkLightShadedImage(); 
  save("Rendered" + name + "Diffuse.png");
}

void selectNormalMapSpecular(File selection) {
  String name = selection.getName();
  name = name.substring(0,name.length() - 8);
  normalMap = loadImage(name + "-Map.png"); 
  darkColor = loadImage(name + "-Dark.png");
  lightColor = loadImage(name + "-Light.png"); 
  background = loadImage(name + "-Background.png");
  specularColor = loadImage(name + "-Specular.png");
  drawSpecularShadedImage();
  save("Rendered" + name + "Specular.png");
}

void setImage(PImage img) {
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      set(x,y,img.get(x,y)); 
    }
  }
}

void drawDarkLightShadedImage() {
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
        
        float T = 0.5*dotProd + 0.5;
        color c0 = darkColor.get(i,j);
        color c1 = lightColor.get(i,j);
        float newR = red(c0)*(1-T) + red(c1)*T;
        float newG = green(c0)*(1-T) + green(c1)*T;
        float newB = blue(c0)*(1-T) + blue(c1)*T;
        
        set(i,j,color(newR,newG,newB)); 
      }
    }
  }
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
        
        set(i,j,color(newR,newG,newB)); 
      }
    }
  }
}

//void generateNormalMap(boolean isSpecular) {
//  for (int i = 0; i < width; i++) {
//    for (int j = 0; j < height; j++) {
//      float x = sin(i*0.05);
//      float y = 0;
//      float z = 1;
      
//      float red = (x + 1)/2;
//      float green = (y + 1)/2;
//      float blue = (z + 1)/2;
      
//      set(i,j,color(red,green,blue));
//    }
//  }
//  save("Generated-Map.png");
//  normalMap = loadImage("Generated-Map.png");
//  String name = "Generated";
//  darkColor = loadImage(name + "-Dark.png");
//  lightColor = loadImage(name + "-Light.png"); 
//  background = loadImage(name + "-Background.png");
//  specularColor = loadImage(name + "-Specular.png");
//  if (isSpecular) {
//    drawSpecularShadedImage();
//      save("RenderedGeneratedSpecular.png");
//  } else {
//    drawDarkLightShadedImage();
//      save("RenderedGeneratedDiffuse.png");
//  }
//}
