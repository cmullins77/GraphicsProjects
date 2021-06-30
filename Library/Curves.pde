public class Curves {
  
  private boolean IS_EDITING_CURVES = false;
  private int COLOR_MODE = 0;
  
  private ArrayList<PVector> customRedPoints = new ArrayList<PVector>();
  private ArrayList<PVector> customGreenPoints = new ArrayList<PVector>();
  private ArrayList<PVector> customBluePoints = new ArrayList<PVector>();
  
  private PImage image;

  
  public void setEditingImage(PImage img) {
    image = img; 
  }
  
  public PImage getEditingImage() {
    return image; 
  }
  
  public void displayNextCurve() {
    if (image == null) {
      return;
    }
    if (IS_EDITING_CURVES) {
        if (COLOR_MODE == 0) {
          COLOR_MODE = 1;
          customGreenPoints = new ArrayList<PVector>();
          customGreenPoints.add(new PVector(0,0));
          customGreenPoints.add(new PVector(width,height));
          drawPoints(customGreenPoints, color(0,255,0));
        } else if (COLOR_MODE == 1) {
          COLOR_MODE = 2;
          customBluePoints = new ArrayList<PVector>();
          customBluePoints.add(new PVector(0,0));
          customBluePoints.add(new PVector(width,height));
          drawPoints(customBluePoints, color(0,0,255));
        } else if (COLOR_MODE == 2) {
          IS_EDITING_CURVES = false;
          inputImage();
        }
      } else {
         IS_EDITING_CURVES = true;
         COLOR_MODE = 0;
         customRedPoints = new ArrayList<PVector>();
         customRedPoints.add(new PVector(0,0));
         customRedPoints.add(new PVector(width,height));
         drawPoints(customRedPoints, color(255,0,0));
      }
  }
  public void handleMouseClick(float x, float y) {
    if (image == null) {
      return;
    }
     if (IS_EDITING_CURVES) {
       switch (COLOR_MODE) {
         case 0:
            addNewPoint(customRedPoints, x, y);
            drawPoints(customRedPoints, color(255,0,0));
            break;
         case 1:
           addNewPoint(customGreenPoints, x, y);
           drawPoints(customGreenPoints, color(0,255,0));
           break;
         case 2:
           addNewPoint(customBluePoints, x, y);
           drawPoints(customBluePoints, color(0,0,255));
           break;
         
       }
     }
  }
  
  
  private void addNewPoint(ArrayList<PVector> pointList, float newX, float newY) {
    for (int i = 1; i < pointList.size(); i++) {
      float x = pointList.get(i).x;
      float y = pointList.get(i).y;
      float mY = height - newY;
      boolean closeX = newX > x - 30 && newX < x + 30;
      boolean closeY = mY > y - 30 && mY < y + 30;
      if (closeX && closeY) {
         if (i != pointList.size() - 1) {
            pointList.remove(i);  
         }
         break;
      } else {
        if (newX < x && newX > 5 && pointList.size() < 16) {
           pointList.add(i, new PVector(newX, mY));
           break;
        }
      }
    }
  }
  
  
  private void drawPoints(ArrayList<PVector> points, color c) {
     fill(c);
     stroke(c);
     background(0,0,0);
     for (int i = 0; i < points.size(); i++) {
       PVector p = points.get(i);
       circle(p.x, height - p.y, 10); 
     }
           
     drawCurve(c, points);
  }
  
  private void drawCurve(color c, ArrayList<PVector> points) {
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
  
  
  private void drawCurveSegment(color c1, PVector p0, PVector p1, PVector v0, PVector v1) {
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
  
    //Curve Adjustmenets //<>//
  
  private void inputImage() {
    PImage img = image;
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
  
  private void setImage(PImage img) {
    int newWidth = min(img.width, 600);
    int newHeight = min(img.height, 600);
    surface.setSize(newWidth, newHeight);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        set(i,j,img.get(i,j)); 
      }
    }
  }

  private void adjustCurve(ArrayList<PVector> redPoints, ArrayList<PVector> redVectors,
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
  }


}
