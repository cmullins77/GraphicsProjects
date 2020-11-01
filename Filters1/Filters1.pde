/*
* Cassie Mullins
* VIZA 654
* Created in Processing with Java
* 
* Applies various filters to selected images
* Blurs: 1 - Gaussian, 2 - Motion, 3 - Smart
* Edge Detection: 4 - Line Drawing, 5 - Emboss using Gray Scale, 6 - Emboss using Color
* Morphological: 7 - Dilation, 8 - Erosion, 9 - Heart Shaped Dilation, 0 - Heart Shaped Erosion
*/


boolean hasText = true;

int radius = 0;
boolean isMorphCircle = true;


void setup() {
   colorMode(RGB, 1.0);
   background(0,0,0);
   size(600,600);
   surface.setResizable(true);
}

void draw() {
  if (hasText) {
    background(0);
    setText();
  }
}

void setText() {
  fill(1);
  textSize(32);
  text("1 - Gaussian Blur", 20, 50);
  text("2 - Motion Blur", 20, 90);
  text("3 - Smart Blur", 20, 130);
  text("4 - Edge Detection", 20, 170);
  text("5 - Emboss Gray Scale", 20, 210);
  text("6 - Emboss Colored", 20, 250);
  text("7 - Dilation", 20, 290);
  text("8 - Erosion", 20, 330);
  text("9 - Heart Shaped Dilation", 20, 370);
  text("0 - Heart Shaped Erosion", 20, 410);
}

void keyPressed() {
  hasText = false;
  if (key == '1') {
    radius = 6;
    selectInput("Select an image to blur", "blurImage"); 
  } else if (key == '2') {
    radius = 12;
    selectInput("Select an image to blur", "motionBlurImage"); 
  } else if (key == '3') {
    radius = 7;
    selectInput("Select an image to blur", "smartBlurImage"); 
  } else if (key == '4') {
    selectInput("Select an image to blur", "edgeDetection"); 
  } else if (key == '5') {
    selectInput("Select an image to color emboss", "emboss"); 
  } else if (key == '6') {
    selectInput("Select an image to emboss", "colorEdgeDetection"); 
  } else if (key == '7') {
    radius = 3;
    isMorphCircle = true;
    selectInput("Select an image to emboss", "dilateImage"); 
  } else if (key == '8') {
    radius = 3;
    isMorphCircle = true;
    selectInput("Select an image to emboss", "erodeImage"); 
  } else if (key == '9') {
    radius = 12;
    isMorphCircle = false;
    selectInput("Select an image to emboss", "dilateImage"); 
  } else if (key == '0') {
    radius = 12;
    isMorphCircle = false;
    selectInput("Select an image to emboss", "erodeImage"); 
  }
}

void blurImage(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  surface.setSize(img.width, img.height);
  
      
  color[][] filteredColors = gaussianBlur(img, radius);
  
  //Set Colors
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      set(x,y,filteredColors[y][x]); 
    }
  }
  save("Blur.jpg");
}


void motionBlurImage(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  surface.setSize(img.width, img.height);
  
  color[][] filteredColors = motionBlur(img, radius);
  //Set Colors
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      set(x,y,filteredColors[y][x]); 
    }
  }
  save("MotionBlur.jpg");
}

void smartBlurImage(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  surface.setSize(img.width, img.height);
      
  color[][] filteredColors = smartBlur(img, radius);
  
  //Set Colors
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      set(x,y,filteredColors[y][x]); 
    }
  }
  save("SmartBlur.jpg");
}

void edgeDetection(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  surface.setSize(img.width, img.height);
  
  int h = 1;
  float[] thetas = {0, 90, 45, 135};
 
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      
      float maxDerivX = 0;
      float maxDerivY = 0;
      
      for (int i = 0; i < thetas.length; i++) {
        float theta = radians(thetas[i]); 
        
        float x0 = abs(x - h * cos(theta));
        float x1 = x + h * cos(theta);
        x1 = x1 >= width ? width - 1 : x1;
        float y0 = abs(y - h * sin(theta));
        float y1 = y + h * sin(theta);
        y1 = y1 >= height ? height - 1: y1;
        
        color c = img.get((int)x0, y);
        float rX0 = red(c);
        float gX0 = green(c);
        float bX0 = blue(c);
        float cX0 = (rX0 + gX0 + bX0)/3.0;
        c = img.get((int)x1, y);
        float rX1 = red(c);
        float gX1 = green(c);
        float bX1 = blue(c);
        float cX1 = (rX1 + gX1 + bX1)/3.0;
        c = img.get(x, (int)y0);
        float rY0 = red(c);
        float gY0 = green(c);
        float bY0 = blue(c);
        float cY0 = (rY0 + gY0 + bY0)/3.0;
        c = img.get(x, (int)y1);
        float rY1 = red(c);
        float gY1 = green(c);
        float bY1 = blue(c);
        float cY1 = (rY1 + gY1 + bY1)/3.0;
        
        float derivX = abs(cX1 - cX0);
        float derivY = abs(cY1 - cY0);
        derivX = (derivX + 1)/2.0;
        derivY = (derivY + 1)/2.0;
        maxDerivX = max(derivX, maxDerivX);
        maxDerivY = max(derivY, maxDerivY);
      }  
      float col = (maxDerivX + maxDerivY)/2.0;
      //println(maxDerivX + " " + maxDerivY + " " + col);
      col = col > 0.54 ? 0 : 1;
      set(x,y, color(col,col,col));
    }
  }
  save("Edges.jpg");
}

void colorEdgeDetection(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  surface.setSize(img.width, img.height);
  
  int h = (int)random(1,4);
  float theta = radians(random(0,360));
 
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      
      float x0 = abs(x - h * cos(theta));
      float x1 = x + h * cos(theta);
      x1 = x1 >= width ? width - 1 : x1;
      float y0 = abs(y - h * sin(theta));
      float y1 = y + h * sin(theta);
      y1 = y1 >= height ? height - 1: y1;
      
      color c = img.get((int)x0, y);
      float rX0 = red(c);
      float gX0 = green(c);
      float bX0 = blue(c);
      c = img.get((int)x1, y);
      float rX1 = red(c);
      float gX1 = green(c);
      float bX1 = blue(c);
      c = img.get(x, (int)y0);
      float rY0 = red(c);
      float gY0 = green(c);
      float bY0 = blue(c);
      c = img.get(x, (int)y1);
      float rY1 = red(c);
      float gY1 = green(c);
      float bY1 = blue(c);
      
      float derivX = rX1 - rX0;
      float derivY = rY1 - rY0;
      derivX = (derivX + 1)/2.0;
      derivY = (derivY + 1)/2.0;     
      float r = 1 - (derivX + derivY)/2.0;
      
      derivX = gX1 - gX0;
      derivY = gY1 - gY0;
      derivX = (derivX + 1)/2.0;
      derivY = (derivY + 1)/2.0;     
      float g = 1 - (derivX + derivY)/2.0;
      
      derivX = bX1 - bX0;
      derivY = bY1 - bY0;
      derivX = (derivX + 1)/2.0;
      derivY = (derivY + 1)/2.0;     
      float b = 1 - (derivX + derivY)/2.0;
      
      set(x,y, color(r,g,b));
    }
  }
  save("ColoredEdges.jpg");
}

void emboss(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  surface.setSize(img.width, img.height);
 
  int h = (int)random(1,5);
  float theta = radians(random(0,360));
 
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      
      float x0 = abs(x - h * cos(theta));
      float x1 = x + h * cos(theta);
      x1 = x1 >= width ? width - 1 : x1;
      float y0 = abs(y - h * sin(theta));
      float y1 = y + h * sin(theta);
      y1 = y1 >= height ? height - 1: y1;
      
      color c = img.get((int)x0, (int)y0);
      float rX00 = red(c);
      float gX00 = green(c);
      float bX00 = blue(c);
      float cX00 = (rX00 + gX00 + bX00)/3.0;
      c = img.get((int)x0, (int)y);
      float rX01 = red(c);
      float gX01 = green(c);
      float bX01 = blue(c);
      float cX01 = (rX01 + gX01 + bX01)/3.0;
      c = img.get((int)x0, (int)y1);
      float rX02 = red(c);
      float gX02 = green(c);
      float bX02 = blue(c);
      float cX02 = (rX02 + gX02 + bX02)/3.0;
      
      float cX0 = cX00 + cX01 + cX02;
      
      c = img.get((int)x1, (int)y0);
      float rX10 = red(c);
      float gX10 = green(c);
      float bX10 = blue(c);
      float cX10 = (rX10 + gX10 + bX10)/3.0;
      c = img.get((int)x1, (int)y);
      float rX11 = red(c);
      float gX11 = green(c);
      float bX11 = blue(c);
      float cX11 = (rX11 + gX11 + bX11)/3.0;
      c = img.get((int)x1, (int)y1);
      float rX12 = red(c);
      float gX12 = green(c);
      float bX12 = blue(c);
      float cX12 = (rX12 + gX12 + bX12)/3.0;
      
      float cX1 = cX10 + cX11 + cX12;
      
      
      c = img.get((int)x0, (int)y0);
      float rY00 = red(c);
      float gY00 = green(c);
      float bY00 = blue(c);
      float cY00 = (rY00 + gY00 + bY00)/3.0;
      c = img.get((int)x, (int)y0);
      float rY01 = red(c);
      float gY01 = green(c);
      float bY01 = blue(c);
      float cY01 = (rY01 + gY01 + bY01)/3.0;
      c = img.get((int)x1, (int)y0);
      float rY02 = red(c);
      float gY02 = green(c);
      float bY02 = blue(c);
      float cY02 = (rY02 + gY02 + bY02)/3.0;
      
      float cY0 = cY00 + cY01 + cY02;
      
      c = img.get((int)x0, (int)y1);
      float rY10 = red(c);
      float gY10 = green(c);
      float bY10 = blue(c);
      float cY10 = (rY10 + gY10 + bY10)/3.0;
      c = img.get((int)x, (int)y1);
      float rY11 = red(c);
      float gY11 = green(c);
      float bY11 = blue(c);
      float cY11 = (rY11 + gY11 + bY11)/3.0;
      c = img.get((int)x1, (int)y1);
      float rY12 = red(c);
      float gY12 = green(c);
      float bY12 = blue(c);
      float cY12 = (rY12 + gY12 + bY12)/3.0;
      
      float cY1 = cY10 + cY11 + cY12;
      
      float derivX = cX1 - cX0;
      float derivY = cY1 - cY0;
      derivX = (derivX + 3)/6.0;
      derivY = (derivY + 3)/6.0;     
      float col = 1 - (derivX + derivY)/2.0;
      
      set(x,y, color(col,col,col));
    }
  }
  save("Emboss.jpg");
}

void dilateImage(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  surface.setSize(img.width, img.height);
      
  color[][] filteredColors = isMorphCircle ? morphFilterCircle(img, radius, false) : morphFilterHeart(img, radius, false);
  //Set Colors
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      set(x,y,filteredColors[y][x]); 
    }
  }
  save("Dilation.jpg");
}

void erodeImage(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  surface.setSize(img.width, img.height);
      
  color[][] filteredColors = isMorphCircle ? morphFilterCircle(img, radius, true) : morphFilterHeart(img, radius, true);
  //Set Colors
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      set(x,y,filteredColors[y][x]); 
    }
  }
  save("Erosion.jpg");
}

//Given Image and filter radius, creates a gaussian blur
color[][] gaussianBlur(PImage img, int filterRadius) {
  int N = filterRadius*2 + 1;
  
   //Calculate Weights
   float[][] weights = new float[N][N];
   float total = 0;
   for (int i = 0; i < N; i++) {
     for (int j = 0; j < N; j++) {
        float u = i - 0.5*(N-1);
        float v = j - 0.5*(N-1);
        float weight = exp(-1*((u*u + v*v)/(filterRadius*filterRadius)));
        weights[i][j] = weight;
        total += weight;
     }
   }
   //Scale Weights
   for (int i = 0; i < N; i++) {
     for (int j = 0; j < N; j++) {
       weights[i][j] = weights[i][j]/total;
     }
   }

  return blur(img, filterRadius, weights);
}

color[][] motionBlur(PImage img, int filterRadius) {
  filterRadius = 2;
  int N = filterRadius*2 + 1;
  float theta = radians(86);
  PVector v0 = new PVector(cos(theta), sin(theta));
  
  //Calculate Weights
  float[][] weights = new float[N][N];
  float total = 0;
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      float u = i - 0.5*(N-1);
      float v = j - 0.5*(N-1);
      //float weight = exp(-1*(abs((v0.x*u) + (v0.y*v))/filterRadius));
      float weight = 1 - abs(-sin(theta)*u + cos(theta)*v);
      if (weight < 0) {
        weight = 0; 
      }
      weights[i][j] = weight;
      total += weight;
    }
  }
  //Scale Weights //<>//
  for (int i = 0; i < N; i++) { //<>//
    for (int j = 0; j < N; j++) {
      weights[i][j] = weights[i][j]/total;
      weights[i][j] = Math.round(weights[i][j] * 100)/100.0;
    }
  }
  return blur(img, filterRadius, weights);      //<>//
}

color[][] blur(PImage img, int filterRadius, float[][] weights) {
  int N = filterRadius*2 + 1;
  color[][] filteredColors = new color[height][width];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float red = 0;
      float green = 0;
      float blue = 0;
      
      //Calculate Filterd Colors
      for (int i = 0 ; i < N; i++) {
        for (int j = 0; j < N; j++) {
           float weight = weights[i][j];
           float u = x + i - 0.5*(N-1);
           float v = y + j - 0.5*(N-1);
           if (u < 0) {
             u = abs(u); 
           } else if (u >= width) {
             u = width - (u - width); 
           }
           if (v < 0) {
             v = abs(v); 
           } else if (v >= height) {
             v = height - (u - height); 
           }
           
           red = red + weight*red(img.get((int)u,(int)v));
           green = green + weight*green(img.get((int)u,(int)v));
           blue = blue + weight*blue(img.get((int)u,(int)v));
        }
      }
      filteredColors[y][x] = color(red,green,blue);
    }
  }
  return filteredColors;
}

color[][] smartBlur(PImage img, int filterRadius) {
  int N = filterRadius*2 + 1;
  
  float blurAmount = 0.2;
  
  color[][] filteredColors = new color[height][width];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      //Calculate Weights
      float[][] weights = new float[N][N];
      float total = 0;
      color origColor = img.get(x,y);
      ArrayList<PVector> colorBlocks = new ArrayList<PVector>();
      for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
           float u = x + i - 0.5*(N-1);
           float v = y + j - 0.5*(N-1);
           if (u < 0) {
             u = abs(u); 
           } else if (u >= width) {
             u = width - (u - width); 
           }
           if (v < 0) {
             v = abs(v); 
           } else if (v >= height) {
             v = height - (u - height); 
           }
           color newColor = img.get((int)u,(int)v);
           
           boolean added = false;
           int index = 0;
           while (!added) {
             if (index >= colorBlocks.size()) {
                colorBlocks.add(new PVector(red(newColor), green(newColor), blue(newColor)));
                break;
             }
             PVector storedColor = colorBlocks.get(index);
             float avgDifference = (abs(red(newColor) - storedColor.x)/3.0) 
                     + (abs(green(newColor) - storedColor.y)/3.0) 
                     + (abs(blue(newColor) - storedColor.z)/3.0);
             if (avgDifference < blurAmount) {
                added = true;
             }
             index++;
           }
         }
       }
       int colorBlockIndex = -1;
       if (colorBlocks.size() <= 4) {
          for (int i = 0; i < colorBlocks.size(); i++) {
            PVector storedColor = colorBlocks.get(i);
            float avgDifference = (abs(red(origColor) - storedColor.x)/3.0) 
                     + (abs(green(origColor) - storedColor.y)/3.0) 
                     + (abs(blue(origColor) - storedColor.z)/3.0);
             if (avgDifference < blurAmount) {
                colorBlockIndex = i;
             }
          }
       }
      for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
           float u = x + i - 0.5*(N-1);
           float v = y + j - 0.5*(N-1);
           if (u < 0) {
             u = abs(u); 
           } else if (u >= width) {
             u = width - (u - width); 
           }
           if (v < 0) {
             v = abs(v); 
           } else if (v >= height) {
             v = height - (u - height); 
           }
           float weight;
           color newColor = img.get((int)u,(int)v);
           u = i - 0.5*(N-1);
           v = j - 0.5*(N-1);
           if (colorBlockIndex == -1) {
              weight = 0;
           } else { 
             float avgDifference = (abs(red(newColor) - colorBlocks.get(colorBlockIndex).x)/3.0) 
                     + (abs(green(newColor) - colorBlocks.get(colorBlockIndex).y)/3.0) 
                     + (abs(blue(newColor) - colorBlocks.get(colorBlockIndex).z)/3.0);
              if (avgDifference < blurAmount) {
                weight = exp(-1*((u*u + v*v)/(filterRadius*filterRadius)));
              } else {
                weight = 0;
              }
           }
          
          // weight = exp(-1*((u*u + v*v)/(filterRadius*filterRadius)))/(1 + 16*diff*diff);
           weights[i][j] = weight;
           total += weight;
         }
       }
      //Scale Weights
      for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
          weights[i][j] = weights[i][j]/total;
        }
      }
  
      float red = 0;
      float green = 0;
      float blue = 0;
     
      //Calculate Filterd Colors
      for (int i = 0 ; i < N; i++) {
        for (int j = 0; j < N; j++) {
           float weight = weights[i][j];
           float u = x + i - 0.5*(N-1);
           float v = y + j - 0.5*(N-1);
           if (u < 0) {
             u = abs(u); 
           } else if (u >= width) {
             u = width - (u - width); 
           }
           if (v < 0) {
             v = abs(v); 
           } else if (v >= height) {
             v = height - (u - height); 
           }
           
           red = red + weight*red(img.get((int)u,(int)v));
           green = green + weight*green(img.get((int)u,(int)v));
           blue = blue + weight*blue(img.get((int)u,(int)v));
        }
      }
      filteredColors[y][x] = color(red,green,blue);
    }
  } 
  return filteredColors;
}

color[][] morphFilterCircle(PImage img, int filterRadius, boolean isErosion) {
  int N = filterRadius*2 + 1;
  
  //Calculate Weights
  float[][] weights = new float[N][N];
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      float u = i - 0.5*(N-1);
      float v = j - 0.5*(N-1);
      float value = u*u + v*v - filterRadius*filterRadius;
      weights[i][j] = value < 0 ? 1 : 0;
    }
  }
      
  return isErosion ? erosion(img, filterRadius, weights) : dilation(img, filterRadius, weights);
}

color[][] morphFilterHeart(PImage img, int filterRadius, boolean isErosion) {
  int N = filterRadius*2 + 1;
  
  //Calculate Weights
  float[][] weights = new float[N][N];
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      float u = i - 0.5*(N-1);
      float v = j - 0.5*(N-1);
      float value = pow((pow(u,2) + pow(v,2) - filterRadius*2),3) - filterRadius*2 * pow(u,2)*pow(v,3);
      weights[i][j] = value < 0 ? 1 : 0;
    }
  }
      
  return isErosion ? erosion(img, filterRadius, weights) : dilation(img, filterRadius, weights);
}

color[][] dilation(PImage img, int filterRadius, float[][] weights) {
  int N = filterRadius*2 + 1;
  color[][] filteredColors = new color[height][width];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float red = 0;
      float green = 0;
      float blue = 0;
      
      float maxAvg = 0;
     
      //Calculate Filterd Colors
      for (int i = 0 ; i < N; i++) {
        for (int j = 0; j < N; j++) {
           float weight = weights[i][j];
           float u = x + i - 0.5*(N-1);
           float v = y + j - 0.5*(N-1);
           if (u < 0) {
             u = abs(u); 
           } else if (u >= width) {
             u = width - (u - width); 
           }
           if (v < 0) {
             v = abs(v); 
           } else if (v >= height) {
             v = height - (u - height); 
           }
           
           float r = weight*red(img.get((int)u,(int)v));
           float g = weight*green(img.get((int)u,(int)v));
           float b = weight*blue(img.get((int)u,(int)v));
           float currentAvg = (r + g + b)/3.0;
           float newMaxAvg = max(currentAvg, maxAvg);
           if (newMaxAvg > maxAvg) {
              maxAvg = newMaxAvg;
              red = r;
              green = g;
              blue = b;
           } 
         }
      }
      filteredColors[y][x] = color(red,green,blue);
    }
  }
  return filteredColors;
}

color[][] erosion(PImage img, int filterRadius, float[][] weights) {
  int N = filterRadius*2 + 1;
  color[][] filteredColors = new color[height][width];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float red = 1;
      float green = 1;
      float blue = 1;
      
      float minAvg = 1;
     
      //Calculate Filterd Colors
      for (int i = 0 ; i < N; i++) {
        for (int j = 0; j < N; j++) {
           float weight = weights[i][j];
           float u = x + i - 0.5*(N-1);
           float v = y + j - 0.5*(N-1);
           if (u < 0) {
             u = abs(u); 
           } else if (u >= width) {
             u = width - 1;
           }
           if (v < 0) {
             v = abs(v); 
           } else if (v >= height) {
             v = height - 1;
           }
           
           if (weight > 0) {
             float r = weight*red(img.get((int)u,(int)v));
             float g = weight*green(img.get((int)u,(int)v));
             float b = weight*blue(img.get((int)u,(int)v));
             float currentAvg = (r + g + b)/3.0;
             float newMinAvg = min(currentAvg, minAvg);
             if (newMinAvg < minAvg) {
                minAvg = newMinAvg;
                red = r;
                green = g;
                blue = b;
             }
           }
         }
      }
      filteredColors[y][x] = color(red,green,blue);
    }
  }
  return filteredColors;
}
