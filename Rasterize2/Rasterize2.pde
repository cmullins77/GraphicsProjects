/*
* Cassie Mullins
* VIZA 654
* Created in Processing with Java
* Generates Convex Polygons, Stars, and Lines that use random noise antialiasing
* 1 = Convex, 2 = Uniform Convex, 3 = Star, 4 = Uniform Star, 5 - Line
*/

float SAMPLES = 5;

void setup() {
   background(0,0,0);
   size(300,300);
   setText();
}

void draw() {

}

void setText() {
   fill(255);
   textSize(24);
   text("1 - Convex", 10, 80);
   text("2 - Star", 10, 110);
   text("3 - Line", 10, 140);
}

void keyPressed() {
  if (key == '1') {
     drawUniformConvex(color(random(5,100),random(5,100),random(5,100)),
         color(random(150,255),random(150,255),random(150,255)),
         (int) random(3, 10), random(40, 80));
   } else if (key == '6') {
     PVector[] points = {new PVector(random(0, 30), random(20, 100)),
                         new PVector(random(75, 100), random(200, 300)),
                         new PVector(random(200, 225), random(200, 300)),
                         new PVector(random(270, 300), random(20, 100)),
                         new PVector(random(60, 240), random(0, 20))};
      drawStar(color(random(5,100),random(5,100),random(5,100)),
         color(random(150,255),random(150,255),random(150,255)),
         points);
   } else if (key == '2') {
     drawUniformStar(color(random(5,100),random(5,100),random(5,100)),
         color(random(150,255),random(150,255),random(150,255)),
         (int) random(5, 8), random(10, 80));
   } else if (key == '3') {
      drawLine(color(random(150,255),random(150,255),random(150,255)),
      color(random(15,200),random(15,100),random(15,100)),
      new PVector(random(0,width),random(0,height)), new PVector(random(0,width),random(0,height)));
   }
}

void drawConvex(color c1, color c2, PVector[] points, float[] thetas) {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      int subPixelsIn = 0;
      for (float m = i; m < i + 1; m = m + 1/SAMPLES) {
        for(float n = j; n < j + 1; n = n + 1/SAMPLES) {
          float totalValue = -1;
          for (int planeNum = 0; planeNum < points.length; planeNum++) {
            PVector v0 = new PVector(cos(thetas[planeNum]), sin(thetas[planeNum]));
            float rm = random(m, m+(1/SAMPLES));
            float rn = random(n, n+(1/SAMPLES));
            float value = v0.x*rm + v0.y*rn - (v0.x*points[planeNum].x + v0.y*points[planeNum].y);
            totalValue = max(totalValue, value);
          }
          if (totalValue < 0) {
            subPixelsIn++;
          }
        }
      }
      color c = lerpColor(c1, c2, subPixelsIn/(SAMPLES*SAMPLES));
      set(i,j,c);
    }
  }
  save("convex_img.png");
} //<>//

void drawStar(color c1, color c2, PVector[] points) {
   for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
         float subPixelsIn = 0; //<>//
         for (float m = i; m < i + 1; m = m + 1/SAMPLES) {
            for(float n = j; n < j + 1; n = n + 1/SAMPLES) {
               int numIn = 0;
               for (int index = 0; index < points.length; index++) {
                  PVector p1 = points[index];
                  PVector p2;
                  if (index == points.length - 2) {
                    p2 = points[0];
                  } else if (index == points.length - 1) {
                     p2 = points[1];
                  } else {
                     p2 = points[index + 2];
                  }
                  
                  float x1 = p1.x;
                  float x2 = p2.x;
                  float y1 = p1.y;
                  float y2 = p2.y;

                  float A = y1 - y2;
                  float B = x2 - x1;
                  float C = x1*y2 - x2*y1;

                  float rm = random(m, m+(1/SAMPLES));
                  float rn = random(n, n+(1/SAMPLES));
                  float value = rm * A + rn * B + C;
                  if (value <= 0) {
                    numIn++;
                  }
               }
               
               if (numIn >= points.length - 1) {
                  subPixelsIn++;
               }
            }
         }
         float lerpValue = subPixelsIn/(SAMPLES*SAMPLES);
         set(i,j, lerpColor(c1,c2, lerpValue));
      }
   }
   save("star_img.png");
}

void drawStar(color c1, color c2, PVector[] points, float[] thetas) {
   for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
         float subPixelsIn = 0;
         for (float m = i; m < i + 1; m = m + 1/SAMPLES) {
            for(float n = j; n < j + 1; n = n + 1/SAMPLES) {
               int numIn = 0;
               for (int planeNum = 0; planeNum < points.length; planeNum++) {
                  PVector v0 = new PVector(cos(thetas[planeNum]), sin(thetas[planeNum]));
                  float rm = random(m, m+(1/SAMPLES));
                  float rn = random(n, n+(1/SAMPLES));
                  float value = v0.x*rm + v0.y*rn - (v0.x*points[planeNum].x + v0.y*points[planeNum].y);
                  if (value <= 0) {
                    numIn++;
                  }
               }
               
               if (numIn >= points.length - 1) {
                  subPixelsIn++;
               }
            }
         }
         float lerpValue = subPixelsIn/(SAMPLES*SAMPLES);
         set(i,j, lerpColor(c1,c2, lerpValue));
      }
   }
   save("star_img.png");
}

void drawUniformConvex(color c1, color c2, int numEdges, float radius) {
   PVector[] points = new PVector[numEdges];
   float[] thetas = new float[numEdges];
   PVector center = new PVector(width/2, height/2);
   PVector point0 = new PVector(1, 0);
   int ind = 0;
   float normalVal = 0;
   for (float theta = radians(0); ind < points.length; theta = theta + radians(360.0/numEdges)) {
      PVector point = new PVector((cos(theta) * point0.x - sin(theta) * point0.y) * radius + center.x,
                                  (cos(theta) * point0.y - sin(theta) * point0.x) * radius + center.y);
      thetas[ind] = normalVal;
      points[ind] = point;
      ind++;
      normalVal = normalVal - radians(360/numEdges);
   }
   drawConvex(c1, c2, points, thetas);
}

void drawUniformStar(color c1, color c2, int numEdges, float radius) {
   PVector[] points = new PVector[numEdges];
   float[] thetas = new float[numEdges];
   PVector center = new PVector(width/2, height/2);
   PVector point0 = new PVector(1, 0);
   int ind = 0;
   float normalVal = 0;
   for (float theta = 0; ind < points.length; theta = theta + radians(360.0/numEdges)) {
      PVector point = new PVector((cos(theta) * point0.x - sin(theta) * point0.y) * radius + center.x,
                                  (cos(theta) * point0.y - sin(theta) * point0.x) * radius + center.y);
      points[ind] = point;
      thetas[ind] = normalVal;
      ind++;
      normalVal = normalVal - radians(360/numEdges);
   }
   drawStar(c1, c2, points, thetas);
}

void drawLine(color c1, color c2, PVector p0, PVector p1) {
  background(c2);
  float dx = p1.x - p0.x;
  float dy = p1.y - p0.y;
  float d = max(abs(dx), abs(dy));
  dx = dx/d;
  dy = dy/d;
  float x = p0.x;
  float y = p0.y;
  while (x < width && y < height && x >= 0 && y >= 0) {
    set((int) x, (int) y, c1);
    x += dx;
    y +=dy;
  }
  x = p0.x;
  y = p0.y;
  while (x < width && y < height && x >= 0 && y >= 0) {
    set((int) x, (int) y, c1);
    x -= dx;
    y -=dy;
  }
  save("line.png");
}
