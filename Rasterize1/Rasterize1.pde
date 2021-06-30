/*
 * Cassie Mullins
 * VIZA 654
 * Created in Processing with Java
 * Generates Half Planes, Circles, and Heart shaped Polygons that use random noise antialiasing
 * 1 = Half Plane, 2 = Circle, 3 = Polygon
 * R to toggle random on/off, while random is off can click and drag to create the half planes and circles
 */
 
float SAMPLES = 5;

boolean pointSelected = false;
PVector centerPoint;
//1 - half plane, 2 - circle
int mode = 1;

boolean randomOn = false;
 
void setup() {
  background(0,0,0);
  size(300,300);
  setText();
}

void draw() {
  if (pointSelected) {
    background(0,0,0);
    fill(255);
    stroke(255);
    circle(centerPoint.x, centerPoint.y, 10);
    line(centerPoint.x, centerPoint.y, mouseX, mouseY);
  }
}

void setText() {
  fill(255);
  textSize(32);
  text("1 - Half Plane", 10, 50);
  text("2 - Circle", 10, 90);
  text("3 - Heart Polygon", 10, 130);
  text("r - random on/off", 10, 170);
  textSize(18);
  text("When random is off, click and", 10, 210);
  text("drag to create planes/circles", 10, 230);
}

void mousePressed() {
  if (!randomOn && mode != 3) {
     pointSelected = true;
     centerPoint = new PVector(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (pointSelected && !randomOn) {
    pointSelected = false;
    if (mode == 1) {
      drawHalfPlane(color(random(5,100),random(5,100),random(5,100)), 
      color(random(150,255),random(150,255),random(150,255)), 
      centerPoint, new PVector(mouseX, mouseY)); 
    } else if (mode == 2) {
      float radius = sqrt((mouseX - centerPoint.x)*(mouseX - centerPoint.x) + (mouseY - centerPoint.y)*(mouseY - centerPoint.y));
      drawCircle(color(random(150,255),random(150,255),random(150,255)), 
      color(random(5,100),random(5,100),random(5,100)), 
      radius, centerPoint.x, centerPoint.y); 
    }
  }
}



void keyPressed() {
  if (key == '1') {
    mode = 1;
    if (randomOn) {
      drawHalfPlane(color(random(5,100),random(5,100),random(5,100)), 
      color(random(150,255),random(150,255),random(150,255)), 
      new PVector(random(20,width-20),random(20,height-20)), random(0, radians(360))); 
    }
  } else if (key == '2') {
    mode = 2;
    if (randomOn) {
      drawCircle(color(random(150,255),random(150,255),random(150,255)), 
      color(random(5,100),random(5,100),random(5,100)), 
      random(10, 150), random(width/2 - (width/10), width/2 + (width/10)), random(height/2 - (height/10), height/2 + (height/10))); 
    }
  } else if (key == '3') {
    mode = 3;
     drawPolygon(color(random(150,255),random(150,255),random(150,255)), 
     color(random(15,200),random(15,100),random(15,100)),
     random(40, 200), random(width/2 - (width/10), width/2 + (width/10)), random(height/2 - (height/10), height/2 + (height/10)));
  } else if (key == 'r') {
    randomOn = !randomOn; 
  }
}

void drawHalfPlane(color c1, color c2, PVector p0, float theta) {
  PVector v0 = new PVector(cos(theta), sin(theta));
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      int subPixelsIn = 0;
      for (float m = 0; m < SAMPLES; m++) {
        for(float n = 0; n < SAMPLES + 1; n++) {
           float rm = random(m, m+(1/SAMPLES));
           float rn = random(n, n+(1/SAMPLES));
           println(rm + " " + rn);
           float value = v0.x*rm + v0.y*rn - (v0.x*p0.x + v0.y*p0.y);
           if (value < 0) {
             subPixelsIn++;
           }
        }
      }
      color c = lerpColor(c1, c2, subPixelsIn/(SAMPLES*SAMPLES));
      set(i,j,c);
    }
  }
  save("half_img.png");
}

void drawHalfPlane(color c1, color c2, PVector p0, PVector v0) {
  v0 = new PVector(v0.x - p0.x, v0.y - p0.y);
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      int subPixelsIn = 0;
      for (float m = i; m < i + 1; m = m + 1/SAMPLES) {
        for(float n = j; n < j + 1; n = n + 1/SAMPLES) {
           float rm = random(m, m+(1/SAMPLES));
           float rn = random(n, n+(1/SAMPLES));
           float value = v0.x*rm + v0.y*rn - (v0.x*p0.x + v0.y*p0.y);
           if (value < 0) {
             subPixelsIn++;
           }
        }
      }
      color c = lerpColor(c1, c2, subPixelsIn/(SAMPLES*SAMPLES));
      set(i,j,c);
    }
  }
  save("half_img.png");
}

void drawCircle(color c1, color c2, float radius, float center_i, float center_j) {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
     float subPixelsIn = 0;
      for (float m = i; m < i + 1; m = m + 1/SAMPLES) {
        for (float n = j; n < j + 1; n = n + 1/SAMPLES) {
          float rm = random(m, m + 1/SAMPLES);
          float rn = random(n, n + 1/SAMPLES);
          float d = pow(radius,2) - (pow(center_i - rm, 2) + pow(center_j - rn, 2));   
          if (d > 0) {
             subPixelsIn++;
          }
        }
      }
     color c = lerpColor(c1, c2, subPixelsIn/(SAMPLES*SAMPLES));
     set(i,j,c);
    }
  }
  save("circle_img.png");
}

void drawPolygon(color c1, color c2, float size, float centerX, float centerY) {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
     float subPixelsIn = 0;
      for (float m = i; m < i + 1; m = m + 1/SAMPLES) {
        for (float n = j; n < j + 1; n = n + 1/SAMPLES) {
          float rm = random(m, m + 1/SAMPLES);
          float rn = random(n, n + 1/SAMPLES);
          float mMod = -1 * (rm - centerX);
          float nMod = -1 * (rn - centerY);
          float d = pow((pow(mMod,2) + pow(nMod,2) - size * 40),3) - 300 * pow(mMod,2)*pow(nMod,3);
          if (d < 0) {
             subPixelsIn++;
          }
        }
      }
     color c = lerpColor(c1, c2, subPixelsIn/(SAMPLES*SAMPLES));
     set(i,j,c);
    }
  }
  save("heart_img.png");
}
