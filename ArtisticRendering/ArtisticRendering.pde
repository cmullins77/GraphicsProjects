/*
* Cassie Mullins
* VIZA 654
* Created in Processing with Java
* 
* Press 1 to bring up Curve Interface and the load image
* Press 2 to select images for Hue Replacement
*/

int maxDistance = 100;
int loops = 1;

void setup() {
   colorMode(RGB, 1.0);
   background(0,0,0);
   size(600,600);
   surface.setResizable(true);
}

void draw() {
 
}

void keyPressed() {
  if (key == '1') {
     selectInput("Select image to modifiy", "inputImage"); 
   } else if (key == '2') {
     selectInput("Select image to modifiy", "inputImage2"); 
   }
}
 //<>// //<>//

//Curve Adjustmenets //<>// //<>//

void inputImage(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  setImage(img); 
}

void inputImage2(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  int newWidth = min(img.width, 600);
  int newHeight = min(img.height, 600);
  surface.setSize(newWidth, newHeight);
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      float currentU = i/width; //<>//
      float currentV = j/height;
      color col = img.get(i,j);
      float uPos = red(col);
      float vPos = green(col);
      
      float adjustU = 0.0/width;
      float adjustV = 0.0/height;
      
      for (int x = 0; x < loops; x++) {
        float uChange = 2 * (uPos - 0.5) * adjustU;
        float vChange = 2 * (vPos - 0.5) * adjustV;
        float uNew = uChange + currentU;
        float vNew = vChange + currentV;
        
        float adjU = uNew;
        float adjV = vNew;
        adjU = abs(adjU);
        adjV = abs(adjV);
        if (adjU > 1) {
         adjU = 1 - (adjU - floor(adjU)); 
        }
        if (adjV > 1) {
          adjV = 1 - (adjV - floor(adjV)); 
        }
        
        int coordX = (int) (adjU * width);
        int coordY = (int) (adjV * height);
        col = img.get(coordX, coordY);
        uPos = red(col);
        vPos = green(col);
      }
      set(i,j, col);
    }
  }
}

void setImage(PImage img) {
  int newWidth = min(img.width, 600);
  int newHeight = min(img.height, 600);
  surface.setSize(newWidth, newHeight);
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      int newI = i;
      int newJ = j;
      for (int x = 0; x < loops; x++) {
        color c = img.get(newI, newJ);
        PVector hsv = getHSV(c);
        float u = (red(c)) * maxDistance * hsv.y;
        float v = (green(c)) *maxDistance * hsv.y;
        newI = (int)(i + u) % newWidth;
        newJ = (int)(j + v) % newHeight;
        if (newI < 0) {
        newI = newWidth + newI;
      } 
      if (newJ < 0) {
        newJ = newHeight + newJ;
      }
      }
      set(i,j,img.get(newI,newJ)); 
    }
  }
} //<>// //<>//

color getRGB(PVector hsv) {
  float h = hsv.x;
  float s = hsv.y;
  float v = hsv.z;
  
  float c = v * s;
  float x = c * (1 - abs(((h/60) % 2) - 1));
  float m = v - c;
  
  color col;
  if (h < 60) {
    col = color(c,x,0); 
  } else if (h < 120) {
    col = color(x,c,0); 
  } else if (h < 180) {
    col = color(0,c,x); 
  } else if (h < 240) {
    col = color(0,x,c); 
  } else if (h < 300) {
    col = color(x,0,c); 
  } else {
    col = color(c,0,x); 
  }
  
  color newCol = color((red(col) + m), (green(col) + m), (blue(col) + m));
  
  return newCol;
}

PVector getHSV(color c) {
  PVector hsv = new PVector(0,0,0);
  float r = red(c);
  float g = green(c);
  float b = blue(c);
     
  float max = max(r,g,b);
  float min = min(r,g,b);
  
   float v = max;
   float s;
   float h;
   
   if (v == 0) {
     s = 0;
     h = 0;
   } else {
     s = (max - min)/max;
     
     float delta = max - min;
     if (delta == 0) {
       h = 0; 
     } else {
       if (r == max) {
         h = (g - b)/delta; 
       } else if (g == max) {
         h = 2 + (b - r)/delta; 
       } else {
         h = 4 + (r - g)/delta; 
       }
       h = h * 60;
       if (h < 0) {
         h += 360; 
       }
     }
   }
   hsv.x = h;
   hsv.y = s;
   hsv.z = v;
   
  return hsv;
}
