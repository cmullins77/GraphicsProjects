/*
* Cassie Mullins
* VIZA 654
*
* 1 - Over, 2 - Subtract, 3 - Multiply, 4 - Max, 5 - Min, 6 - Chosen Alpha, 7 - Generate Alpha, 8 - Chroma Key
* Choose Foreground First and then Background
* For Chosen alpha choose alpha first
*/


PImage firstImg;
PImage alphaImg;

void setup() {
   background(0,0,0);
   size(600,600);
   colorMode(RGB, 1.0);
   setText();
}

void draw() {

}

void setText() {
   fill(1);
   textSize(32);
   text("1 - Over", 10, 40);
   text("2 - Subtract", 10, 80);
   text("3 - Multiply", 10, 120);
   text("4 - Max", 10, 160);
   text("5 - Min", 10, 200);
   text("6 - Choose Alpha to Combine Images", 10, 240);
   text("7 - Generate Alpha", 10, 280);
   text("8 - Chroma Key", 10, 320);
}

void keyPressed() {
  if (key == '1') {
      selectInput("Select Image to Add", "selectFirstOverImage");
   } else if (key == '2') {
      selectInput("Select Image to Add", "selectFirstSubtractImage");
   } else if (key == '3') {
      selectInput("Select Image to Add", "selectFirstMultiplyImage");
   } else if (key == '4') {
      selectInput("Select Image to Add", "selectFirstMaxImage");
   } else if (key == '5') {
      selectInput("Select Image to Add", "selectFirstMinImage");
   } else if (key == '6') {
      selectInput("Select Image to Add", "selectAlphaAddWithAlphaImage");
   } else if (key == '7') {
      selectInput("Select Image to Add", "selectAlphaImage");
   } else if (key == '8') {
      selectInput("Select Image to Add", "selectFirstChromaKeyImage");
   }
}

void selectFirstOverImage(File selection) {
  firstImg = loadImage(selection.getAbsolutePath()); 
  selectInput("Select Image to Add", "selectSecondOverImage");
}

void selectFirstSubtractImage(File selection) {
  firstImg = loadImage(selection.getAbsolutePath()); 
  selectInput("Select Image to Add", "selectSecondSubtractImage");
}

void selectFirstMultiplyImage(File selection) {
  firstImg = loadImage(selection.getAbsolutePath()); 
  selectInput("Select Image to Add", "selectSecondMultiplyImage");
}

void selectFirstMaxImage(File selection) {
  firstImg = loadImage(selection.getAbsolutePath()); 
  selectInput("Select Image to Add", "selectSecondMaxImage");
}

void selectFirstMinImage(File selection) {
  firstImg = loadImage(selection.getAbsolutePath()); 
  selectInput("Select Image to Add", "selectSecondMinImage");
}

void selectFirstAddWithAlphaImage(File selection) {
  firstImg = loadImage(selection.getAbsolutePath()); 
  selectInput("Select Image to Add", "selectSecondAddWithAlphaImage");
}

void selectAlphaAddWithAlphaImage(File selection) {
  alphaImg = loadImage(selection.getAbsolutePath()); 
  selectInput("Select Image to Add", "selectFirstAddWithAlphaImage");
}

void selectFirstChromaKeyImage(File selection) {
  firstImg = loadImage(selection.getAbsolutePath()); 
  selectInput("Select Image to Add", "selectSecondChromaKeyImage");
}

void selectSecondOverImage(File selection) {
  PImage secondImg = loadImage(selection.getAbsolutePath()); 
  
  float alpha1 = random(0.2,0.8);
  float alpha2 = 1;
  
  float newAlpha = alpha1 + alpha2*(1-alpha1);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float red =  red(firstImg.get(x,y)) * alpha1 + red(secondImg.get(x,y))*(1-alpha1);
      float green =  green(firstImg.get(x,y)) * alpha1 + green(secondImg.get(x,y))*(1-alpha1);
      float blue =  blue(firstImg.get(x,y)) * alpha1 + blue(secondImg.get(x,y))*(1-alpha1);
      
      set(x,y,color(red,green,blue, newAlpha));
    }
  }
  save("Over.jpg");
}

void selectSecondSubtractImage(File selection) {
  PImage secondImg = loadImage(selection.getAbsolutePath()); 
  
  float alpha1 = 1;
  float alpha2 = 1;
  
  float newAlpha = alpha1 + alpha2*(1-alpha1);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float red =  red(firstImg.get(x,y)) * alpha1 - red(secondImg.get(x,y)) * alpha2 + red(secondImg.get(x,y))*(1-alpha1);
      float green =  green(firstImg.get(x,y)) * alpha1 - green(secondImg.get(x,y)) * alpha2 + green(secondImg.get(x,y))*(1-alpha1);
      float blue =  blue(firstImg.get(x,y)) * alpha1 - blue(secondImg.get(x,y)) * alpha2 + blue(secondImg.get(x,y))*(1-alpha1);
      
      set(x,y,color(red,green,blue, newAlpha));
    }
  }
  save("Subtract.jpg");
}

void selectSecondMultiplyImage(File selection) {
  PImage secondImg = loadImage(selection.getAbsolutePath()); 
 
  float alpha1 = random(0.6,1);
  float alpha2 = 1;
  
  float newAlpha = alpha1 + alpha2*(1-alpha1);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float red =  red(firstImg.get(x,y)) * alpha1 * red(secondImg.get(x,y)) * alpha2 + red(secondImg.get(x,y))*(1-alpha1);
      float green =  green(firstImg.get(x,y)) * alpha1 * green(secondImg.get(x,y)) * alpha2 + green(secondImg.get(x,y))*(1-alpha1);
      float blue =  blue(firstImg.get(x,y)) * alpha1 * blue(secondImg.get(x,y)) * alpha2 + blue(secondImg.get(x,y))*(1-alpha1);
      
      set(x,y,color(red,green,blue, newAlpha));
    }
  }
  save("Multiply.jpg");
}

void selectSecondMaxImage(File selection) {
  PImage secondImg = loadImage(selection.getAbsolutePath()); 
  
  float alpha1 = random(0.6,1);
  float alpha2 = 1;
  
  float newAlpha = alpha1 + alpha2*(1-alpha1);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float red =  max(red(firstImg.get(x,y)) * alpha1, red(secondImg.get(x,y)) * alpha2) + red(secondImg.get(x,y))*(1-alpha1);
      float green =  max(green(firstImg.get(x,y)) * alpha1, green(secondImg.get(x,y)) * alpha2) + green(secondImg.get(x,y))*(1-alpha1);
      float blue =  max(blue(firstImg.get(x,y)) * alpha1, blue(secondImg.get(x,y)) * alpha2) + blue(secondImg.get(x,y))*(1-alpha1);
      
      set(x,y,color(red,green,blue, newAlpha));
    }
  }
  save("Max.jpg");
}

void selectSecondMinImage(File selection) {
  PImage secondImg = loadImage(selection.getAbsolutePath()); 
  
  float alpha1 = random(0.6,1);
  float alpha2 = 1;
  
  float newAlpha = alpha1 + alpha2*(1-alpha1);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float red =  min(red(firstImg.get(x,y)) * alpha1, red(secondImg.get(x,y)) * alpha2) + red(secondImg.get(x,y))*(1-alpha1);
      float green =  min(green(firstImg.get(x,y)) * alpha1, green(secondImg.get(x,y)) * alpha2) + green(secondImg.get(x,y))*(1-alpha1);
      float blue =  min(blue(firstImg.get(x,y)) * alpha1, blue(secondImg.get(x,y)) * alpha2) + blue(secondImg.get(x,y))*(1-alpha1);
      
      set(x,y,color(red,green,blue, newAlpha));
    }
  }
  save("Min.jpg");
}

void selectSecondAddWithAlphaImage(File selection) {
  PImage secondImg = loadImage(selection.getAbsolutePath()); 
 
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float alpha1 = (red(alphaImg.get(x,y)) + green(alphaImg.get(x,y)) + blue(alphaImg.get(x,y)))/3;
      float alpha2 = 1;
      
      float newAlpha = alpha1 + alpha2*(1-alpha1);
      
      float red =  red(firstImg.get(x,y)) * alpha1 + red(secondImg.get(x,y))*(1-alpha1);
      float green =  green(firstImg.get(x,y)) * alpha1 + green(secondImg.get(x,y))*(1-alpha1);
      float blue =  blue(firstImg.get(x,y)) * alpha1 + blue(secondImg.get(x,y))*(1-alpha1);
      
      set(x,y,color(red,green,blue, newAlpha));
    }
  }
  save("AddWithAlpha.jpg");
}

void selectAlphaImage(File selection) {
  PImage img =  loadImage(selection.getAbsolutePath()); 
  
  float minHue = 218;
  float maxHue = 260;
  float edgeRange = 60;
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      PVector hsv = getHSV(img.get(x,y));
      if (hsv.x > minHue && hsv.x < maxHue) {
        set(x,y,color(0,0,0));
      } else if (hsv.x + edgeRange  > minHue && hsv.x < minHue) {
        float val = (minHue - hsv.x)/edgeRange;
        set(x,y,color(val, val, val));
      } else if (hsv.x - edgeRange  < maxHue && hsv.x > maxHue) {
        float val = (hsv.x - maxHue)/edgeRange;
        set(x,y,color(val, val, val));
      } else {
        set(x,y, color(1,1,1));
      }
    }
  }
  save("Alpha.jpg");
}

void selectSecondChromaKeyImage(File selection) {
  PImage secondImg =  loadImage(selection.getAbsolutePath()); 
  
  float minHue = 218;
  float maxHue = 260;
  float edgeRange = 60;
  
  color[][] alphaColors = new color[width][height];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      PVector hsv = getHSV(firstImg.get(x,y));
      if (hsv.x > minHue && hsv.x < maxHue) {
        alphaColors[x][y] = color(0,0,0);
      } else if (hsv.x + edgeRange  > minHue && hsv.x < minHue) {
        float val = (minHue - hsv.x)/edgeRange;
        alphaColors[x][y] = color(val,val,val);
      } else if (hsv.x - edgeRange  < maxHue && hsv.x > maxHue) {
        float val = (hsv.x - maxHue)/edgeRange;
        alphaColors[x][y] = color(val,val,val);
      } else {
        alphaColors[x][y] = color(1,1,1);
      }
    }
  }
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float alpha1 = red(alphaColors[x][y]);
      float alpha2 = 1;
      
      float newAlpha = alpha1 + alpha2*(1-alpha1);
      
      float red =  red(firstImg.get(x,y)) * alpha1 + red(secondImg.get(x,y))*(1-alpha1);
      float green =  green(firstImg.get(x,y)) * alpha1 + green(secondImg.get(x,y))*(1-alpha1);
      float blue =  blue(firstImg.get(x,y)) * alpha1 + blue(secondImg.get(x,y))*(1-alpha1);
      
      set(x,y,color(red,green,blue, newAlpha));
    }
  }
  save("ChromaKey.jpg");
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
} //<>// //<>//
