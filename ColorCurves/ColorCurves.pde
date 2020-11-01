/*
* Cassie Mullins
* VIZA 654
* Created in Processing with Java
* 
* Press 1 to bring up Curve Interface and the load image
* Press 2 to select images for Hue Replacement
*/


boolean isCurveEditMode = false;
int colorMode = 0;

ArrayList<PVector> customRedPoints = new ArrayList<PVector>();
ArrayList<PVector> customGreenPoints = new ArrayList<PVector>();
ArrayList<PVector> customBluePoints = new ArrayList<PVector>();

PImage modifiedImage;

boolean hasText = true;


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
  textSize(24);
  text("1 - Manipulate Color Curves", 20, 50);
  text("Click to add Points to Curve", 60, 90);
  text("Click Points to Remove Them", 60, 130);
  text("Press 1 to Move to Next", 60, 170);
  
  text("2 - Replace Hues", 20, 240);
  text("First Select Image to Modify", 60, 280);
  text("Then Select Image to Get Hues From", 60, 320);
}

void keyPressed() {
  hasText = false;
   if (key == '1') {
     background(0);
      if (isCurveEditMode) {
        if (colorMode == 0) {
          colorMode = 1;
          customGreenPoints = new ArrayList<PVector>();
          customGreenPoints.add(new PVector(0,0));
          customGreenPoints.add(new PVector(width,height));
          drawPoints(customGreenPoints, color(0,255,0));
        } else if (colorMode == 1) {
          colorMode = 2;
          customBluePoints = new ArrayList<PVector>();
          customBluePoints.add(new PVector(0,0));
          customBluePoints.add(new PVector(width,height));
          drawPoints(customBluePoints, color(0,0,255));
        } else if (colorMode == 2) {
          isCurveEditMode = false;
          selectInput("Select a file to process:", "inputImage"); 
        }
      } else {
         isCurveEditMode = true;
         colorMode = 0;
         customRedPoints = new ArrayList<PVector>();
         customRedPoints.add(new PVector(0,0));
         customRedPoints.add(new PVector(width,height));
         drawPoints(customRedPoints, color(255,0,0));
      }
   } else if (key == '2') {
     selectInput("Select image to modifiy", "getImage1"); 
   }
}

void mousePressed() {
  if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < width) {
     if (isCurveEditMode) {
       if (colorMode == 0) { //<>//
         addNewPoint(customRedPoints);
         drawPoints(customRedPoints, color(255,0,0));
       } else if (colorMode == 1) {
         addNewPoint(customGreenPoints);
         drawPoints(customGreenPoints, color(0,255,0));
       } else if (colorMode == 2) {
         addNewPoint(customBluePoints);
         drawPoints(customBluePoints, color(0,0,255));
       }
     }
  }
}

//Curve Interface

void addNewPoint(ArrayList<PVector> pointList) {
  for (int i = 1; i < pointList.size(); i++) {
    float x = pointList.get(i).x;
    float y = pointList.get(i).y;
    float mY = height - mouseY;
    boolean closeX = mouseX > x - 30 && mouseX < x + 30;
    boolean closeY = mY > y - 30 && mY < y + 30;
    if (closeX && closeY) {
       if (i != pointList.size() - 1) {
          pointList.remove(i);  
       }
       break;
    } else {
      if (mouseX < x && mouseX > 5 && pointList.size() < 16) {
         pointList.add(i, new PVector(mouseX, mY));
         break;
      }
    }
  }
}

void drawPoints(ArrayList<PVector> points, color c) {
   fill(c);
   stroke(c);
   background(0,0,0);
   for (int i = 0; i < points.size(); i++) {
     PVector p = points.get(i);
     circle(p.x, height - p.y, 10); 
   }
         
   drawCurve(c, points);
} //<>//

void drawCurve(color c, ArrayList<PVector> points) {
  for (int i = 0; i < points.size() - 1; i++) {
    float x0 = points.get(i).x;
    float y0 = height - points.get(i).y;
    float x1 = points.get(i+1).x;
    float y1 = height - points.get(i+1).y;
    
    float scaleFactor = 300;
    float theta = radians(-45);
    drawCurveSegment(c, new PVector(x0,y0), new PVector(x1, y1), 
    new PVector(scaleFactor * cos(theta), scaleFactor*sin(theta)), 
    new PVector(scaleFactor * cos(theta), scaleFactor*sin(theta)));
  }
}

void drawCurveSegment(color c1, PVector p0, PVector p1, PVector v0, PVector v1) {
  for (float t = 0; t <= 1; t += 0.001) {
    float h0 = 2*t*t*t - 3*t*t + 1;
    float h1 = -2*t*t*t + 3*t*t;
    float h2 = t*t*t - 2*t*t + t;
    float h3 = t*t*t - t*t;
    int x = (int)(h0*p0.x + h1*p1.x + h2*v0.x + h3*v1.x);
    int y = (int)(h0*p0.y + h1*p1.y + h2*v0.y + h3*v1.y);
    y = y > height - 1 ? height - 1 : y < 0 ? 0 : y;
    x = x > width - 1 ? width - 1 : x < 0 ? 0 : x;
    set(x,y,c1);
  }
}

//Curve Adjustmenets //<>// //<>//

void inputImage(File selection) {
  PImage img = loadImage(selection.getAbsolutePath());
  setImage(img);
  
  int scaleFactor = 300;
  float theta = radians(-45);
  ArrayList<PVector> customRedVectors = new ArrayList<PVector>();
  for (int i = 0; i < customRedPoints.size() - 1; i++) {
    customRedVectors.add(new PVector(scaleFactor*cos(theta), scaleFactor*sin(theta)));
  }
  ArrayList<PVector> customGreenVectors = new ArrayList<PVector>();
  for (int i = 0; i < customGreenPoints.size() - 1; i++) {
    customGreenVectors.add(new PVector(scaleFactor*cos(theta), scaleFactor*sin(theta)));
  }
  ArrayList<PVector> customBlueVectors = new ArrayList<PVector>();
  for (int i = 0; i < customBluePoints.size() - 1; i++) {
    customBlueVectors.add(new PVector(scaleFactor*cos(theta), scaleFactor*sin(theta)));
  }
  adjustCurve(customRedPoints, customRedVectors, customGreenPoints, customGreenVectors, customBluePoints, customBlueVectors);
}

void setImage(PImage img) {
  int newWidth = min(img.width, 600);
  int newHeight = min(img.height, 600);
  surface.setSize(newWidth, newHeight);
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      set(i,j,img.get(i,j)); 
    }
  }
}
 //<>//
void adjustCurve(ArrayList<PVector> redPoints, ArrayList<PVector> redVectors,
                 ArrayList<PVector> greenPoints, ArrayList<PVector> greenVectors,
                 ArrayList<PVector> bluePoints, ArrayList<PVector> blueVectors) {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      try {
        color c = get(x,y);
        float r = red(c);
        float g = green(c);
        float b = blue(c);
         
        //Red
        int curveIndex = 0;
        for (curveIndex = 0; curveIndex < redPoints.size() - 1; curveIndex++) {
          if (r < redPoints.get(curveIndex + 1).x) {
             break;
          }
        }
        float x0 = redPoints.get(curveIndex).x;
        float x1 = redPoints.get(curveIndex + 1).x;
        float y0 = redPoints.get(curveIndex).y;
        float y1 = redPoints.get(curveIndex + 1).y;
        float t = (r - x0)/(x1 - x0);
        float h0 = 2*t*t*t - 3*t*t + 1;
        float h1 = -2*t*t*t + 3*t*t;
        float h2 = t*t*t - 2*t*t + t;
        float h3 = t*t*t - t*t;
        float newR = y0*h0 + y1*h1 + redVectors.get(curveIndex).x*h2 + redVectors.get(curveIndex + 1).x*h3;
        newR = newR > 1 ? 1 : newR < 0 ? 0 : newR;
        
        //Green
        curveIndex = 0;
        for (curveIndex = 0; curveIndex < greenPoints.size() - 1; curveIndex++) {
          if (g < greenPoints.get(curveIndex + 1).x) {
             break;
          }
        }
        x0 = greenPoints.get(curveIndex).x;
        x1 = greenPoints.get(curveIndex + 1).x;
        y0 = greenPoints.get(curveIndex).y;
        y1 = greenPoints.get(curveIndex + 1).y;
        t = (g - x0)/(x1 - x0);
        h0 = 2*t*t*t - 3*t*t + 1;
        h1 = -2*t*t*t + 3*t*t;
        h2 = t*t*t - 2*t*t + t;
        h3 = t*t*t - t*t;
        float newG = y0*h0 + y1*h1 + greenVectors.get(curveIndex).x*h2 + greenVectors.get(curveIndex + 1).x*h3;
        newG = newG > 1 ? 1 : newG < 0 ? 0 : newG;
        
        //Blue
        curveIndex = 0;
        for (curveIndex = 0; curveIndex < bluePoints.size() - 1; curveIndex++) {
          if (b < bluePoints.get(curveIndex + 1).x) {
             break;
          }
        }
        x0 = bluePoints.get(curveIndex).x;
        x1 = bluePoints.get(curveIndex + 1).x;
        y0 = bluePoints.get(curveIndex).y;
        y1 = bluePoints.get(curveIndex + 1).y;
        t = (g - x0)/(x1 - x0);
        h0 = 2*t*t*t - 3*t*t + 1;
        h1 = -2*t*t*t + 3*t*t;
        h2 = t*t*t - 2*t*t + t;
        h3 = t*t*t - t*t;
        float newB = y0*h0 + y1*h1 + blueVectors.get(curveIndex).x*h2 + blueVectors.get(curveIndex + 1).x*h3;
        newB = newB > 1 ? 1 : newB < 0 ? 0 : newB;
        
        set(x, y, color(newR, newG, newB)); 
      } catch (Exception e) {
        //println("Encountered Exception adjusting curves: " + e.toString() + " " + e.getStackTrace()[0].getLineNumber()); 
      }
    }
  }
  save("AdjustedImage.jpg");
} //<>//

//Hue Replacement 

void getImage1(File selection) {
  modifiedImage = loadImage(selection.getAbsolutePath());
  selectInput("Get Image for Hue Replacement", "modifyHues"); 
}

void modifyHues(File selection) {
  PImage huesImage = loadImage(selection.getAbsolutePath());
  for (int x = 0; x < modifiedImage.width; x++) {
    for (int y = 0; y < modifiedImage.height; y++) {
      color newColor = modifiedImage.get(x,y);
      PVector hsv1 = getHSV(newColor);
      if (x < huesImage.width && y < huesImage.height) {
        PVector hsv2 = getHSV(huesImage.get(x,y));
        newColor = getRGB(new PVector(hsv2.x, hsv1.y, hsv1.z));
      }
      set(x,y,newColor);
    }
  }
  save("HueReplacedImage.jpg");
}

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
