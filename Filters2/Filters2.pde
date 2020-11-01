/*
* Cassie Mullins
* VIZA 654
* Created in Processing with Java
* 
* Applies various filters to selected images
* 1: Blur - Select Image to Blur and then Second Image to Control the Blur
* 2: Dilation - Select Image to Dilate and then Second Image to Control Dilation
* 3: Erosion - Select Image to Erode and then Second Image to Control Erosion
* 4: Line Drawing - Select Image to Draw
* 5: Used to Generate Images for Website, Runs through all filters with all provided images (takes a while to run)
*/


boolean hasText = true;

int radius = 0;
boolean isMorphCircle = true;

PImage originalImg;
PImage secondImg;

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
  text("1 - HSV Motion Blur", 20, 50);
  text("2 - Dilation", 20, 90);
  text("3 - Erosion", 20, 130);
  text("4 - Line Drawing", 20, 170);
  text("5 - Run All With Provided Images", 20, 210);
}

void keyPressed() {
  hasText = false;
  if (key == '1') {
    selectInput("Select an image to blur", "selectOriginalImageHSVBlur"); 
  } else if (key == '2') {
    selectInput("Select an image to blur", "selectOriginalImageDilation"); 
  } else if (key == '3') {
    selectInput("Select an image to blur", "selectOriginalImageErosion"); 
  } else if (key == '4') {
    selectInput("Select an image to blur", "blackLineDrawingImage"); 
  } else if (key == '5') {
     runAll();
  }
}

void runAll() {
  surface.setSize(600, 600);
  String[] origImagePaths = {"Art", "Flowers", "Stripes", "Vegas"};
  String[] hsvImagePaths = {"HSV1.jpg", "HSV2.jpg", "HSV3.jpg", "HSV4.jpg"};
  String[] morphImagePaths = {"Morph1.jpg","Morph2.jpg","Morph3.jpg"};
  
  //HSV Blur
  for (int i = 0; i < origImagePaths.length; i++) {
    String imgName = origImagePaths[i];
    PImage origImg = loadImage(imgName + ".jpg");
    for (int j = 1; j <= hsvImagePaths.length; j++) {
      String hsvImagePath = hsvImagePaths[j-1];
      PImage hsvImg = loadImage(hsvImagePath);
      color[][] filteredColors = hsvVectorMapBlur(origImg, hsvImg, 1);
      
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          set(x,y,filteredColors[y][x]); 
        }
      }
      save(imgName + "Blur" + j + ".jpg");
    }
  }
  
  //Dilation
  for (int i = 0; i < origImagePaths.length; i++) {
    String imgName = origImagePaths[i];
    PImage origImg = loadImage(imgName + ".jpg");
    for (int j = 1; j <= morphImagePaths.length; j++) {
      String morphImagePath = morphImagePaths[j-1];
      PImage morphImg = loadImage(morphImagePath);
      color[][] filteredColors = dilation(origImg, morphImg, 2);
      
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          set(x,y,filteredColors[y][x]); 
        }
      }
      save(imgName + "Dilation" + j + ".jpg");
    }
  }
  
  //Erosion
  for (int i = 0; i < origImagePaths.length; i++) {
    String imgName = origImagePaths[i];
    PImage origImg = loadImage(imgName + ".jpg");
    for (int j = 1; j <= morphImagePaths.length; j++) {
      String morphImagePath = morphImagePaths[j-1];
      PImage morphImg = loadImage(morphImagePath);
      color[][] filteredColors = erosion(origImg, morphImg, 2);
      
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          set(x,y,filteredColors[y][x]); 
        }
      }
      save(imgName + "Erosion" + j + ".jpg");
    }
  }
  
  //Line
  for (int i = 0; i < origImagePaths.length; i++) {
    String imgName = origImagePaths[i];
    PImage origImg = loadImage(imgName + ".jpg");
      
    PVector[] points = {new PVector(0,0), new PVector(0.4,0), new PVector(0.5,1), new PVector(0.6,0), new PVector(1,0)};
     
    int h = 2;
      
    color[][] filteredColors = lineDrawing(origImg, points, h, true);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        set(x,y, filteredColors[x][y]); 
       }
     }
     save(imgName + "Line.jpg");
  }
}

void selectOriginalImageHSVBlur(File selection) {
  originalImg = loadImage(selection.getAbsolutePath());
  surface.setSize(originalImg.width, originalImg.height);
  selectInput("Select an image to blur", "selectSecondImageHSVBlur"); 
}

void selectSecondImageHSVBlur(File selection) {
  secondImg = loadImage(selection.getAbsolutePath());
  
  color[][] filteredColors = hsvVectorMapBlur(originalImg, secondImg, 1);
  //Set Colors
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      set(x,y,filteredColors[y][x]); 
    }
  }
  save("HSVBlur.jpg");
}

void selectOriginalImageDilation(File selection) {
  originalImg = loadImage(selection.getAbsolutePath());
  surface.setSize(originalImg.width, originalImg.height);
  selectInput("Select an image to blur", "selectSecondImageDilation"); 
}

void selectSecondImageDilation(File selection) {
  secondImg = loadImage(selection.getAbsolutePath());
  
  color[][] filteredColors = dilation(originalImg, secondImg, 2);
  //Set Colors
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      set(x,y,filteredColors[y][x]); 
    }
  }
  save("Dilation.jpg");
}

void selectOriginalImageErosion(File selection) {
  originalImg = loadImage(selection.getAbsolutePath());
  surface.setSize(originalImg.width, originalImg.height);
  selectInput("Select an image to blur", "selectSecondImageErosion"); 
}

void selectSecondImageErosion(File selection) {
  secondImg = loadImage(selection.getAbsolutePath());
  
  color[][] filteredColors = erosion(originalImg, secondImg, 2);
  //Set Colors
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      set(x,y,filteredColors[y][x]); 
    }
  }
  save("Erosion.jpg");
}

color[][] dilation(PImage img, PImage colorImage, int filterRadius) {
  int N = filterRadius*2 + 1;
  color[][] filteredColors = new color[height][width];
  for (int x = 0; x < width; x++) { //<>//
    for (int y = 0; y < height; y++) {
      float red = red(img.get(x,y));
      float green = green(img.get(x,y));
      float blue = blue(img.get(x,y));
      
      float maxAvg = 0;
      
  
      //Calculate Weights
      float[][] weights = new float[N][N];
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
          float value = red(colorImage.get((int)u,(int)v));
          weights[i][j] = value > 0.5 ? 1 : 0;
        }
      }
     
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

color[][] erosion(PImage img, PImage colorImage, int filterRadius) {
  int N = filterRadius*2 + 1;
  color[][] filteredColors = new color[height][width];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float red = red(img.get(x,y));
      float green = green(img.get(x,y));
      float blue = blue(img.get(x,y));
      
      float minAvg = 1;
      
  
      //Calculate Weights
      float[][] weights = new float[N][N];
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
          float value = red(colorImage.get((int)u,(int)v));
          weights[i][j] = value > 0.5 ? 1 : 0;
        }
      }
     
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
           float newMinAvg = min(currentAvg, minAvg);
           if (weight > 0 && newMinAvg < minAvg) {
              minAvg = newMinAvg;
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

color[][] hsvVectorMapBlur(PImage img, PImage colorImg, int filterRadius) {
  int N = filterRadius*2 + 1;
      
  color[][] filteredColors = new color[height][width];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      //Calculate Weights
      PVector currentHSV = getHSV(colorImg.get(x,y));
      float theta = radians(currentHSV.x);
      N = filterRadius*2 + 1 + (int)(currentHSV.z*20);
      PVector v0 = new PVector(cos(theta), sin(theta));
      
      //Calculate Weights
      float[][] weights = new float[N][N];
      float total = 0;
      for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
          float u = i - 0.5*(N-1);
          float v = j - 0.5*(N-1);
          float value = abs((v0.x*u) + (v0.y*v));
          float  weight = exp(-1*value/filterRadius);
          if (value < 2) {
             weight*=10;
          }
          
          weights[i][j] = weight;
          total += weight;
        }
      }
      //println(weights[0]);
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

void blackLineDrawingImage(File selection) {
  PVector[] points = {new PVector(0,0), new PVector(0.4,0), new PVector(0.5,1), new PVector(0.6,0), new PVector(1,0)};
  PImage img = loadImage(selection.getAbsolutePath());
  surface.setSize(img.width, img.height);
 
  int h = 2;
  
  color[][] filteredColors = lineDrawing(img, points, h, true);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      set(x,y, filteredColors[x][y]); 
    }
  }
  save("LineDrawing.jpg");
}

color[][] lineDrawing(PImage img, PVector[] points, int h, boolean isLineDrawing) {
  float[] thetas = {0, 90, 45, 135};
  
  color[][] filteredColors = new color[width][height];
 
 for (int x = 0; x < width; x++) {
  for (int y = 0; y < height; y++) {  
    color newColor = color(0,0,0);
    for (int index = 0; index < thetas.length; index++) {
      float theta = thetas[index];
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
        
        color currentColor = adjustColor(points, color(col,col,col), isLineDrawing);
        newColor = color(red(newColor) + red(currentColor)/thetas.length, green(newColor) + green(currentColor)/thetas.length, blue(newColor) + blue(currentColor)/thetas.length);
      }
      filteredColors[x][y] = newColor;
    }
  }
  return filteredColors;
}

color adjustColor(PVector[] points, color c, boolean isLineDrawing) {
  color newColor = c;
      try {
        float r = red(c);
        float g = green(c);
        float b = blue(c);
         
        //Red
        int curveIndex = 0;
        for (curveIndex = 0; curveIndex < points.length - 1; curveIndex++) {
          if (r < points[curveIndex + 1].x) {
             break;
          }
        }
        float x0 = points[curveIndex].x;
        float x1 = points[curveIndex + 1].x;
        float y0 = points[curveIndex].y;
        float y1 = points[curveIndex + 1].y;
        float t = (r - x0)/(x1 - x0);
        float newR = y0*(1-t) + y1*t;
        newR = newR > 1 ? 1 : newR < 0 ? 0 : newR;
        
        //Green
        curveIndex = 0;
        for (curveIndex = 0; curveIndex < points.length - 1; curveIndex++) {
          if (g < points[curveIndex + 1].x) {
             break;
          }
        }
        x0 = points[curveIndex].x;
        x1 = points[curveIndex + 1].x;
        y0 = points[curveIndex].y;
        y1 = points[curveIndex + 1].y;
        t = (g - x0)/(x1 - x0);
        float newG = y0*(1-t) + y1*t;
        newG = newG > 1 ? 1 : newG < 0 ? 0 : newG;
        
        //Blue
        curveIndex = 0;
        for (curveIndex = 0; curveIndex < points.length - 1; curveIndex++) {
          if (b < points[curveIndex + 1].x) {
             break;
          }
        }
        x0 = points[curveIndex].x;
        x1 = points[curveIndex + 1].x;
        y0 = points[curveIndex].y;
        y1 = points[curveIndex + 1].y;
        t = (g - x0)/(x1 - x0);
        float newB = y0*(1-t) + y1*t;
        newB = newB > 1 ? 1 : newB < 0 ? 0 : newB;
        newColor = color(newR, newG, newB);
        if (isLineDrawing) {
          if (newR > 0.60 && newG > 0.60 && newB > 0.60) {
            newColor = color(1,1,1);
          } else {
            newColor = color(0,0,0); 
          }
        }
      } catch (Exception e) {
        //println("Encountered Exception adjusting curves: " + e.toString() + " " + e.getStackTrace()[0].getLineNumber()); 
      }
      return newColor;
}
