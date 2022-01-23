/*
* Cassie Mullins
* VIZA 654
* Created in Processing with Java
* 
* Transformations using a Matrix Stack which allows for multiple different transformations to be applied to the image
*/

float[] xVals = {300, 600, 600, 600, 300, 300, 300};
float[] yVals = {300, 300, 0, 0,0, 300, 300};
float[] zVals = {300, 300, 300, 600, 600, 600, 300};
int frame_no = 0;

void setup() {
  colorMode(RGB, 1.0);
   background(1);
   size(600,600);
   drawCurve();
}

void draw() {
  float t = (frame_no % 600)/600.0;
  t = 1/3.0;
  background(1);
  fill(0);
  drawCurve();
  drawFrenetFrame(t);
  frame_no++;
}

void keyPressed() {
  if (key == '1') {
    drawFrenetFrame(0);
  }
}

void drawFrenetFrame(float t) {
  float x = pow((1-t),6)*xVals[0] + 6*t*pow((1-t),5)*xVals[1] + 15*pow(t,2)*pow((1-t),4)*xVals[2] 
    + 20*pow(t,3)*pow((1-t),3)*xVals[3] + 15*pow(t,4)*pow((1-t),2)*xVals[4] + 6*pow(t,5)*(1-t)*xVals[5] + pow(t,6)*xVals[6];
    float y = pow((1-t),6)*yVals[0] + 6*t*pow((1-t),5)*yVals[1] + 15*pow(t,2)*pow((1-t),4)*yVals[2] 
    + 20*pow(t,3)*pow((1-t),3)*yVals[3] + 15*pow(t,4)*pow((1-t),2)*yVals[4] + 6*pow(t,5)*(1-t)*yVals[5] + pow(t,6)*yVals[6];
    float z = pow((1-t),6)*zVals[0] + 6*t*pow((1-t),5)*zVals[1] + 15*pow(t,2)*pow((1-t),4)*zVals[2] 
    + 20*pow(t,3)*pow((1-t),3)*zVals[3] + 15*pow(t,4)*pow((1-t),2)*zVals[4] + 6*pow(t,5)*(1-t)*zVals[5] + pow(t,6)*zVals[6];
   circle(x,y,10);
   
   float tx = 6*(pow(1-t,5)*(xVals[1]-xVals[0]) + 5*t*pow((1-t),4)*(xVals[2]-xVals[1]) 
   + 10*pow(t,2)*pow((1-t),3)*(xVals[3]-xVals[2]) + 10*pow(t,3)*pow((1-t),2)*(xVals[4]-xVals[5])
   + 5*pow(t,4)*(1-t)*(xVals[5]-xVals[4]) + pow(t,5)*(xVals[6]-xVals[5]));
   float ty = 6*(pow(1-t,5)*(yVals[1]-yVals[0]) + 5*t*pow((1-t),4)*(yVals[2]-yVals[1]) 
   + 10*pow(t,2)*pow((1-t),3)*(yVals[3]-yVals[2]) + 10*pow(t,3)*pow((1-t),2)*(yVals[4]-yVals[5])
   + 5*pow(t,4)*(1-t)*(yVals[5]-yVals[4]) + pow(t,5)*(yVals[6]-yVals[5]));
   float tz = 6*(pow(1-t,5)*(zVals[1]-zVals[0]) + 5*t*pow((1-t),4)*(zVals[2]-zVals[1]) 
   + 10*pow(t,2)*pow((1-t),3)*(zVals[3]-zVals[2]) + 10*pow(t,3)*pow((1-t),2)*(zVals[4]-zVals[5])
   + 5*pow(t,4)*(1-t)*(zVals[5]-zVals[4]) + pow(t,5)*(zVals[6]-zVals[5]));
   
   float tdist = sqrt(tx*tx + ty*ty + tz*tz);
   tx = 100*tx/tdist;
   ty = 100*ty/tdist;
   tz = 100*tz/tdist;
   
   float nx = 30*(pow((1-t),4)*(xVals[2]-2*xVals[1]+xVals[0]) + 4*t*pow((1-t),3)*(xVals[3]-2*xVals[2]+xVals[1]) 
   + 6*pow(t,2)*pow((1-t),2)*(xVals[4]-2*xVals[3]+xVals[2])+ 4*pow(t,3)*(1-t)*(xVals[5]-2*xVals[4]+xVals[3]) 
   + pow(t,4)*(xVals[6]-2*xVals[5]+xVals[4]));
   float ny = 30*(pow((1-t),4)*(yVals[2]-2*yVals[1]+yVals[0]) + 4*t*pow((1-t),3)*(yVals[3]-2*yVals[2]+yVals[1]) 
   + 6*pow(t,2)*pow((1-t),2)*(yVals[4]-2*yVals[3]+yVals[2])+ 4*pow(t,3)*(1-t)*(yVals[5]-2*yVals[4]+yVals[3]) 
   + pow(t,4)*(yVals[6]-2*yVals[5]+yVals[4]));
   float nz = 30*(pow((1-t),4)*(zVals[2]-2*zVals[1]+zVals[0]) + 4*t*pow((1-t),3)*(zVals[3]-2*zVals[2]+zVals[1]) 
   + 6*pow(t,2)*pow((1-t),2)*(zVals[4]-2*zVals[3]+zVals[2])+ 4*pow(t,3)*(1-t)*(zVals[5]-2*zVals[4]+zVals[3]) 
   + pow(t,4)*(zVals[6]-2*zVals[5]+zVals[4]));
    
   float ndist = sqrt(nx*nx + ny*ny + nz*nz);
   nx = 100*nx/ndist;
   ny = 100*ny/ndist;
   nz = 100*nz/ndist;
   
   line(x,y,tx+x,ty+y);
   line(x,y,nx+x,ny+y);
}

void drawCurve() {
  float t = 1;
  float prevx = pow((1-t),6)*xVals[0] + 6*t*pow((1-t),5)*xVals[1] + 15*pow(t,2)*pow((1-t),4)*xVals[2] 
    + 20*pow(t,3)*pow((1-t),3)*xVals[3] + 15*pow(t,4)*pow((1-t),2)*xVals[4] + 6*pow(t,5)*(1-t)*xVals[5] + pow(t,6)*xVals[6];
  float prevy = pow((1-t),6)*yVals[0] + 6*t*pow((1-t),5)*yVals[1] + 15*pow(t,2)*pow((1-t),4)*yVals[2] 
    + 20*pow(t,3)*pow((1-t),3)*yVals[3] + 15*pow(t,4)*pow((1-t),2)*yVals[4] + 6*pow(t,5)*(1-t)*yVals[5] + pow(t,6)*yVals[6];
  float prevz = pow((1-t),6)*zVals[0] + 6*t*pow((1-t),5)*zVals[1] + 15*pow(t,2)*pow((1-t),4)*zVals[2] 
    + 20*pow(t,3)*pow((1-t),3)*zVals[3] + 15*pow(t,4)*pow((1-t),2)*zVals[4] + 6*pow(t,5)*(1-t)*zVals[5] + pow(t,6)*zVals[6];
  for(t = 0; t <= 1; t += 1/60.0) {
    float x = pow((1-t),6)*xVals[0] + 6*t*pow((1-t),5)*xVals[1] + 15*pow(t,2)*pow((1-t),4)*xVals[2] 
    + 20*pow(t,3)*pow((1-t),3)*xVals[3] + 15*pow(t,4)*pow((1-t),2)*xVals[4] + 6*pow(t,5)*(1-t)*xVals[5] + pow(t,6)*xVals[6];
    float y = pow((1-t),6)*yVals[0] + 6*t*pow((1-t),5)*yVals[1] + 15*pow(t,2)*pow((1-t),4)*yVals[2] 
    + 20*pow(t,3)*pow((1-t),3)*yVals[3] + 15*pow(t,4)*pow((1-t),2)*yVals[4] + 6*pow(t,5)*(1-t)*yVals[5] + pow(t,6)*yVals[6];
    float z = pow((1-t),6)*zVals[0] + 6*t*pow((1-t),5)*zVals[1] + 15*pow(t,2)*pow((1-t),4)*zVals[2] 
    + 20*pow(t,3)*pow((1-t),3)*zVals[3] + 15*pow(t,4)*pow((1-t),2)*zVals[4] + 6*pow(t,5)*(1-t)*zVals[5] + pow(t,6)*zVals[6];
    line(prevx, prevy, x, y);
    prevx = x;
    prevy = y;
    prevz = z;
  }
}
