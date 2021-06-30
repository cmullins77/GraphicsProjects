/*
* Cassie Mullins
* VIZA 654
* Created in Processing with Java
* 
* Press 1 to bring up Curve Interface and the load image
* Press 2 to select images for Hue Replacement
*/


//boolean isCurveEditMode = false;
//int colorMode = 0;

//ArrayList<PVector> customRedPoints = new ArrayList<PVector>();
//ArrayList<PVector> customGreenPoints = new ArrayList<PVector>();
//ArrayList<PVector> customBluePoints = new ArrayList<PVector>();

//PImage modifiedImage;

boolean hasText = true;

Curves curves;


void setup() {
   colorMode(RGB, 1.0);
   background(0,0,0);
   size(600,600);
   surface.setResizable(true);
   curves = new Curves();
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
  if (key == '0') {
    selectInput("Select image to modifiy", "setEditingImage"); 
  }
   if (key == '1') {
     background(0);
     curves.displayNextCurve();
   } else if (key == '2') {
     selectInput("Select image to modifiy", "getImage1"); 
   }
}

void mousePressed() {
  if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < width) {
    curves.handleMouseClick(mouseX, mouseY); //<>//
  }
}

void setEditingImage(File selection) {
  curves.setEditingImage(loadImage(selection.getAbsolutePath())); 
} //<>// //<>// //<>// //<>//
////Hue Replacement 

//void getImage1(File selection) {
//  modifiedImage = loadImage(selection.getAbsolutePath());
//  selectInput("Get Image for Hue Replacement", "modifyHues"); 
//}

//void modifyHues(File selection) {
//  PImage huesImage = loadImage(selection.getAbsolutePath());
//  for (int x = 0; x < modifiedImage.width; x++) {
//    for (int y = 0; y < modifiedImage.height; y++) {
//      color newColor = modifiedImage.get(x,y);
//      PVector hsv1 = getHSV(newColor);
//      if (x < huesImage.width && y < huesImage.height) {
//        PVector hsv2 = getHSV(huesImage.get(x,y));
//        newColor = getRGB(new PVector(hsv2.x, hsv1.y, hsv1.z));
//      }
//      set(x,y,newColor);
//    }
//  }
//  save("HueReplacedImage.jpg");
//}

//color getRGB(PVector hsv) {
//  float h = hsv.x;
//  float s = hsv.y;
//  float v = hsv.z;
  
//  float c = v * s;
//  float x = c * (1 - abs(((h/60) % 2) - 1));
//  float m = v - c;
  
//  color col;
//  if (h < 60) {
//    col = color(c,x,0); 
//  } else if (h < 120) {
//    col = color(x,c,0); 
//  } else if (h < 180) {
//    col = color(0,c,x); 
//  } else if (h < 240) {
//    col = color(0,x,c); 
//  } else if (h < 300) {
//    col = color(x,0,c); 
//  } else {
//    col = color(c,0,x); 
//  }
  
//  color newCol = color((red(col) + m), (green(col) + m), (blue(col) + m));
  
//  return newCol;
//}

//PVector getHSV(color c) {
//  PVector hsv = new PVector(0,0,0);
//  float r = red(c);
//  float g = green(c);
//  float b = blue(c);
     
//  float max = max(r,g,b);
//  float min = min(r,g,b);
  
//   float v = max;
//   float s;
//   float h;
   
//   if (v == 0) {
//     s = 0;
//     h = 0;
//   } else {
//     s = (max - min)/max;
     
//     float delta = max - min;
//     if (delta == 0) {
//       h = 0; 
//     } else {
//       if (r == max) {
//         h = (g - b)/delta; 
//       } else if (g == max) {
//         h = 2 + (b - r)/delta; 
//       } else {
//         h = 4 + (r - g)/delta; 
//       }
//       h = h * 60;
//       if (h < 0) {
//         h += 360; 
//       }
//     }
//   }
//   hsv.x = h;
//   hsv.y = s;
//   hsv.z = v;
   
//  return hsv;
//}
