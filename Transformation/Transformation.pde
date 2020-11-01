/*
* Cassie Mullins
* VIZA 654
* Created in Processing with Java
* 
* Transformations using a Matrix Stack which allows for multiple different transformations to be applied to the image
*/


boolean hasText = true;
float SAMPLES = 3;
boolean FILL_BACKGROUND = false;

MatrixStack stack = new MatrixStack();

void setup() {
   colorMode(RGB, 1.0);
   background(0,0,0);
   size(900,900);
   
   setText();
}

void draw() {

}

void setText() {
  fill(1);
  textSize(32);
  text("1 - Rotate", 20, 50);
  text("2 - Uniform Scale", 20, 90);
  text("3 - Non Uniform Scale", 20, 130);
  text("4 - Sheer", 20, 170);
  text("5 - Mirror", 20, 210);
  text("6 - Translate", 20, 250);
  text("7 - Perspective", 20, 290);
  text("8 - Bilinear", 20, 330);
  text("9 - Inverse", 20, 370);
}

void keyPressed() {
  hasText = false;
  if (key == '1') {
    selectInput("Select an image to blur", "selectRotateImg"); 
  } else if (key == '2') {
    selectInput("Select an image to blur", "selectUniformScaleImg"); 
  } else if (key == '3') {
    selectInput("Select an image to blur", "selectNonUniformScaleImg"); 
  } else if (key == '4') {
    selectInput("Select an image to blur", "selectSheerImg"); 
  } else if (key == '5') {
    selectInput("Select an image to blur", "selectMirrorImg"); 
  } else if (key == '6') {
    selectInput("Select an image to blur", "selectTranslateImg"); 
  } else if (key == '7') {
    selectInput("Select an image to blur", "selectPerspectiveImg"); 
  } else if (key == '8') {
    selectInput("Select an image to blur", "selectBilinearImg"); 
  } else if (key == '9') {
    selectInput("Select an image to blur", "selectInverseImg"); 
  }
}


void selectBilinearImg(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  
  //applyBilinear(img, new PVector(100,100), new PVector(800,300), new PVector(50, 850), new PVector(700,800));
  drawBackground();
  applyBilinear(img, new PVector(400,0), new PVector(500,-100), new PVector(10, 700), new PVector(1000,500));
}

void selectUniformScaleImg(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  
  float scale = random(0.5,1.5);
  stack = new MatrixStack();
  stack.gtScale(1.0/scale, 1.0/scale);
  color[][] colors = applyTransformations(img);
  
  drawBackground();
  for (int x = 0; x < colors.length; x++) {
    for (int y = 0; y < colors[0].length; y++) {
      set(x,y,colors[x][y]); 
    }
  }
  save("UniformScaledImg.jpg");
}

void selectMirrorImg(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  
  stack = new MatrixStack();
  stack.gtTranslate(img.width/2.0, img.height/2.0);
  stack.gtScale(-1f, -1f);
  stack.gtTranslate(-1.0*(img.width/2), -1.0*(img.height/2));
  color[][] colors = applyTransformations(img);
  
  drawBackground();
  for (int x = 0; x < colors.length; x++) {
    for (int y = 0; y < colors[0].length; y++) {
      set(x,y,colors[x][y]); 
    }
  }
  save("MirrorImg.jpg");
}

void selectNonUniformScaleImg(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  
  stack = new MatrixStack();
  float xscale = 1.0/random(0.5,1.5);
  float factor = random(1);
  float yscale = factor > 0.5 ? xscale * random(1.5,2) : xscale * random(0.67);
  stack.gtScale(xscale, yscale);
  color[][] colors = applyTransformations(img);
  
  drawBackground();
  for (int x = 0; x < colors.length; x++) {
    for (int y = 0; y < colors[0].length; y++) {
      set(x,y,colors[x][y]); 
    }
  }
  save("NonUniformScaledImg.jpg");
}

void selectTranslateImg(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  
  stack = new MatrixStack();
  stack.gtTranslate(-1*random(25,150), -1*random(25,150));
  color[][] colors = applyTransformations(img);
  
  drawBackground();
  for (int x = 0; x < colors.length; x++) {
    for (int y = 0; y < colors[0].length; y++) {
      set(x,y,colors[x][y]); 
    }
  }
  save("TranslateImg.jpg");
}

void selectSheerImg(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  
  stack = new MatrixStack();
  float sheerX = random(width/4)/img.width;
  float sheerY = random(height/4)/img.height;
  //stack.gtTranslate(img.width/2.0 - width/2, img.height/2.0 - height/2);
  stack.gtSheer(-1*sheerX, -1*sheerY);
  color[][] colors = applyTransformations(img);
  
  drawBackground();
  for (int x = 0; x < colors.length; x++) {
    for (int y = 0; y < colors[0].length; y++) {
      set(x,y,colors[x][y]); 
    }
  }
  save("SheerImg.jpg");
}

void selectPerspectiveImg(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  
  stack = new MatrixStack();
  float yPersp = -1/random(width - 600, width + 600);
  float xPersp = -1/random(height - 600, height + 600);
  stack.gtTranslate(img.width/2.0, img.height/2.0);
  stack.gtPerspective(xPersp, yPersp);
   stack.gtTranslate(-1.0*(width/2), -1.0*(height/2));
  color[][] colors = applyTransformations(img);
  
  drawBackground();
  for (int x = 0; x < colors.length; x++) {
    for (int y = 0; y < colors[0].length; y++) {
      set(x,y,colors[x][y]); 
    }
  }
  save("PerspectiveImg.jpg");
}

void selectRotateImg(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  
  stack = new MatrixStack();
  stack.gtTranslate(img.width/2.0, img.height/2.0);
  stack.gtRotate(random(0,360));
  stack.gtTranslate(-1.0*(width/2), -1.0*(height/2));
  color[][] colors = applyTransformations(img);
  
  drawBackground();
  for (int x = 0; x < colors.length; x++) {
    for (int y = 0; y < colors[0].length; y++) {
      set(x,y,colors[x][y]); 
    }
  }
  save("RotateImg.jpg");
}

color[][] applyTransformations(PImage img) {
  color[][] colors = new color[width][height];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < width; y++) {
      float r = 0;
      float g = 0;
      float b = 0;
      for (float m = 0; m < SAMPLES; m++) {
        for(float n = 0; n < SAMPLES; n++) {
           float rm = random(0, 1/SAMPLES); //<>//
           float rn = random(0, 1/SAMPLES);
           float newX = x + m/SAMPLES + rm;
           float newY = y + n/SAMPLES + rn;
           Float[] newPos = getPoint(newX, newY); 
           int u = (int)(newPos[0].floatValue());
           int v = (int)(newPos[1].floatValue());
           if (FILL_BACKGROUND) {
             u = u % img.width;
             v = v % img.height;
             u = u < 0 ? u + img.width : u;
             v = v < 0 ? v + img.height : v; 
           }
           if (u >= 0 && u < img.width && v >= 0 && v < img.height) {
             r = r + red(img.get(u,v));
             g = g + green(img.get(u,v));
             b = b + blue(img.get(u,v)); 
           }
        }
      }
      r = r/(SAMPLES*SAMPLES);
      g = g/(SAMPLES*SAMPLES);
      b = b/(SAMPLES*SAMPLES);
      color c = color(r,g,b);
      colors[x][y] = c;
    }
  }
  return colors;
} //<>// //<>//

void drawBackground() {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      set(x,y, color(0,0,0)); 
    }
  }
}

Float[] getPoint(float x, float y) {
   Float[][] ctm = stack.getCTM();
   Float newX = (ctm[0][0] * x) + (ctm[0][1] * y) + (ctm[0][2] * 1);
   Float newY = (ctm[1][0] * x) + (ctm[1][1] * y) + (ctm[1][2] * 1);
   Float w = (ctm[2][0] * x) + (ctm[2][1] * y) + (ctm[2][2] * 1); //<>//
   if (w != 1) {
     newX = newX/w;
     newY = newY/w;
   }
   Float[] newPoint = {newX, newY};
   return newPoint;
}

PVector toScreen(PVector p) {
  return new PVector(p.x*width, p.y*height);
}

PVector toScaled(PVector p) {
  return new PVector(p.x/width, p.y/height);
}

void applyBilinear(PImage img, PVector newP0, PVector newP1, PVector newP2, PVector newP3) {
  for (float x = 0; x < img.width; x++) { //<>//
    for (float y = 0; y < img.height; y++) {
      float t = x/width;
      float s = y/width;
      
      PVector point = new PVector((1-s)*((1-t)*newP0.x + t*newP1.x) + s*((1-t)*newP2.x + t*newP3.x), 
      (1-s)*((1-t)*newP0.y + t*newP1.y) + s*((1-t)*newP2.y + t*newP3.y));
      set((int) point.x, (int) point.y, img.get((int)x,(int)y));
    }
  } //<>//
  save("Bilinear.jpg");
} //<>//

void selectInverseImg(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  float randHeight = random(10, 30);
  float randWidth = random(0.01, 0.06);
  color[][] colors = new color[width][height];
  for (int x = 0; x < width; x++) { //<>//
    for (int y = 0; y < height; y++) {
      float r = 0;
      float g = 0;
      float b = 0;
      for (float m = 0; m < SAMPLES; m++) {
        for(float n = 0; n < SAMPLES; n++) {
           float rm = random(0, 1/SAMPLES);
           float rn = random(0, 1/SAMPLES);
           float newX = x + m/SAMPLES + rm;
           float newY = y + n/SAMPLES + rn;
           int u = (int)((randHeight*cos(randWidth*newY)) + newX);
           int v = (int)((randHeight*sin(randWidth*newX)) + newY);
           if (FILL_BACKGROUND) {
             u = u % img.width;
             v = v % img.height;
             u = u < 0 ? u + img.width : u;
             v = v < 0 ? v + img.height : v; 
           }
           if (u >= 0 && u < img.width && v >= 0 && v < img.height) {
             r = r + red(img.get(u,v));
             g = g + green(img.get(u,v));
             b = b + blue(img.get(u,v)); 
           }
        }
      }
      r = r/(SAMPLES*SAMPLES);
      g = g/(SAMPLES*SAMPLES);
      b = b/(SAMPLES*SAMPLES);
      color c = color(r,g,b);
      colors[x][y] = c;
    }
  }
  
  drawBackground();
  for (int x = 0; x < colors.length; x++) {
    for (int y = 0; y < colors[0].length; y++) {
      set(x,y,colors[x][y]); 
    }
  }
  save("InverseImg.jpg");
}
