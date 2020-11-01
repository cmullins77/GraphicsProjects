/*
* Cassie Mullins
* VIZA 654
*
* 1 - Random Noise, 2 - Error, 3 - Ordered, 4 - Interactive in Black & White, 5 - Interactive in Color
* Choose Foreground First and then Background
* Note: you may have to rerun the program to switch between the 2 versions of the interactive program
*/

  
import processing.video.*;

Capture cam;
boolean isCameraMode = false;
boolean isDitheringColor = true;

PImage firstImg;
PImage alphaImg;

void setup() {
   background(0,0,0);
   size(600,600);
   colorMode(RGB, 1.0);
   setText();
}

void draw() {
  if (isCameraMode) {
     if (cam.available() == true) {
      cam.read();
      }
      // The following does the same, and is faster when just drawing the image
      // without any additional resizing, transformations, or tint.
      set(0, 0, cam); 
      ditherCurrentImage();
  }
}

void setText() {
   fill(1);
   textSize(32);
   text("1 - Random Noise", 10, 40);
   text("2 - Error", 10, 80);
   text("3 - Ordered", 10, 120);
   text("4 - Black and White Interactive", 10, 160);
   text("5 - Color Interactive", 10, 200);
}

void keyPressed() {
  isCameraMode = false;
  background(0);
  if (key == '1') {
      selectInput("Select Image to Add Random Noise to", "selectRandomNoiseImage");
   } else if (key == '2') {
      selectInput("Select Image to Add Error Dither to", "selectErrorImage");
   } else if (key == '3') {
      selectInput("Select Image to Add Ordered Dither to", "selectOrderedImage");
   } else if (key == '4') {
     interactiveDithering();
     isDitheringColor = false;
   } else if (key == '5') {
     interactiveDithering();
     isDitheringColor = true;
   }
}

void selectFirstOverImage(File selection) {
  firstImg = loadImage(selection.getAbsolutePath()); 
  selectInput("Select Image to Add", "selectSecondOverImage");
}

void selectRandomNoiseImage(File selection) {
  PImage img = loadImage(selection.getAbsolutePath()); 
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float randomVal = random(-0.5, 0.5);
      float r = red(img.get(x,y)) + randomVal;
      float g = green(img.get(x,y)) + randomVal;
      float b = blue(img.get(x,y)) + randomVal;
      r = r < 0.5 ? 0 : 1;
      g = g < 0.5 ? 0 : 1;
      b = b < 0.5 ? 0 : 1;
      set(x,y, color(r,g,b));
    }
  }
  save("RandomNoise.jpg");
} 
 //<>//
void selectErrorImage(File selection) {
  PImage img = loadImage(selection.getAbsolutePath()); 
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      //Red
      float red = red(img.get(x,y));
      float currentVal = red + 0.5 < 1 ? 0 : 1;
      float error = red(img.get(x,y)) - currentVal;
      int numNeighbors = 4;
      if (x >= width - 1) {
        numNeighbors = 1; 
      }
      if (y <= 0) {
        numNeighbors--; 
      }
      if (y >= height - 1) {
        numNeighbors -= 2; 
      }
      if (numNeighbors > 0) {
        float val = error/numNeighbors;
        if (x < width - 1) {
          color c = img.get(x+1,y);
          float col = red(c) + val;
          img.set(x + 1, y, color(col, green(c), blue(c))); 
          if (y > 0) {
            c = img.get(x+1,y-1);
            col = red(c) + val;
            img.set(x + 1, y - 1, color(col, green(c), blue(c))); 
          }
          if (y < height - 1) {
            c = img.get(x+1,y+1);
            col = red(c) + val;
            img.set(x + 1, y + 1, color(col, green(c), blue(c))); 
          }
        }
        if (y < height - 1) {
           color c = img.get(x,y+1);
           float col = red(c) + val;
           img.set(x, y + 1, color(col, green(c), blue(c))); 
        }
      }
      red = currentVal;
      
      //Green
      float green= green(img.get(x,y));
      currentVal = green + 0.5 < 1 ? 0 : 1;
      error = green(img.get(x,y)) - currentVal;
      if (numNeighbors > 0) {
        float val = error/numNeighbors;
        if (x < width - 1) {
          color c = img.get(x+1,y);
          float col = green(c) + val;
          img.set(x + 1, y, color(red(c), col, blue(c))); 
          if (y > 0) {
            c = img.get(x+1,y-1);
            col = green(c) + val;
            img.set(x + 1, y - 1, color(red(c), col, blue(c))); 
          }
          if (y < height - 1) {
            c = img.get(x+1,y+1);
            col = green(c) + val;
            img.set(x + 1, y + 1, color(red(c), col, blue(c))); 
          }
        }
        if (y < height - 1) {
           color c = img.get(x,y+1);
           float col = green(c) + val;
           img.set(x, y + 1, color(red(c), col, blue(c))); 
        }
      }
      green = currentVal;
      
      //Blue
      float blue = blue(img.get(x,y));
      currentVal = blue + 0.5 < 1 ? 0 : 1;
      error = blue(img.get(x,y)) - currentVal;
      if (numNeighbors > 0) {
        float val = error/numNeighbors;
        if (x < width - 1) {
          color c = img.get(x+1,y);
          float col = blue(c) + val;
          img.set(x + 1, y, color(red(c), green(c), col)); 
          if (y > 0) {
            c = img.get(x+1,y-1);
            col = blue(c) + val;
            img.set(x + 1, y - 1, color(red(c), green(c), col)); 
          }
          if (y < height - 1) {
            c = img.get(x+1,y+1);
            col = blue(c) + val;
            img.set(x + 1, y + 1, color(red(c), green(c), col)); 
          }
        }
        if (y < height - 1) {
           color c = img.get(x,y+1);
           float col = blue(c) + val;
           img.set(x, y + 1, color(red(c), green(c), col)); 
        }
      }
      blue = currentVal;
      
      set(x,y, color(red,green,blue));
    }
  }
  save("Error.jpg");
}

void interactiveDithering() {
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    return;
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }      
  isCameraMode = true;
}

void ditherCurrentImage() {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      //Red
      float red = red(get(x,y));
      float currentVal = red + 0.5 < 1 ? 0 : 1;
      float error = red(get(x,y)) - currentVal;
      int numNeighbors = 4;
      if (x >= width - 1) {
        numNeighbors = 1; 
      }
      if (y <= 0) {
        numNeighbors--; 
      }
      if (y >= height - 1) {
        numNeighbors -= 2; 
      }
      if (numNeighbors > 0) {
        float val = error/numNeighbors;
        if (x < width - 1) {
          color c = get(x+1,y);
          float col = red(c) + val;
          set(x + 1, y, color(col, green(c), blue(c))); 
          if (y > 0) {
            c = get(x+1,y-1);
            col = red(c) + val;
            set(x + 1, y - 1, color(col, green(c), blue(c))); 
          }
          if (y < height - 1) {
            c = get(x+1,y+1);
            col = red(c) + val;
            set(x + 1, y + 1, color(col, green(c), blue(c))); 
          }
        }
        if (y < height - 1) {
           color c = get(x,y+1);
           float col = red(c) + val;
           set(x, y + 1, color(col, green(c), blue(c))); 
        }
      }
      red = currentVal;
      float green= currentVal;
      float blue = currentVal;
      
      if (isDitheringColor) {
        //Green
        green= green(get(x,y));
        currentVal = green + 0.5 < 1 ? 0 : 1;
        error = green(get(x,y)) - currentVal;
        if (numNeighbors > 0) {
          float val = error/numNeighbors;
          if (x < width - 1) {
            color c = get(x+1,y);
            float col = green(c) + val;
            set(x + 1, y, color(red(c), col, blue(c))); 
            if (y > 0) {
              c = get(x+1,y-1);
              col = green(c) + val;
              set(x + 1, y - 1, color(red(c), col, blue(c))); 
            }
            if (y < height - 1) {
              c = get(x+1,y+1);
              col = green(c) + val;
              set(x + 1, y + 1, color(red(c), col, blue(c))); 
            }
          }
          if (y < height - 1) {
             color c = get(x,y+1);
             float col = green(c) + val;
             set(x, y + 1, color(red(c), col, blue(c))); 
          }
        }
        green = currentVal;
        
        //Blue
        blue = blue(get(x,y));
        currentVal = blue + 0.5 < 1 ? 0 : 1;
        error = blue(get(x,y)) - currentVal;
        if (numNeighbors > 0) {
          float val = error/numNeighbors;
          if (x < width - 1) {
            color c = get(x+1,y);
            float col = blue(c) + val;
            set(x + 1, y, color(red(c), green(c), col)); 
            if (y > 0) {
              c = get(x+1,y-1);
              col = blue(c) + val;
              set(x + 1, y - 1, color(red(c), green(c), col)); 
            }
            if (y < height - 1) {
              c = get(x+1,y+1);
              col = blue(c) + val;
              set(x + 1, y + 1, color(red(c), green(c), col)); 
            }
          }
          if (y < height - 1) {
             color c = get(x,y+1);
             float col = blue(c) + val;
             set(x, y + 1, color(red(c), green(c), col)); 
          }
        }
        blue = currentVal;
      }
      
      set(x,y, color(red,green,blue));
    }
  }
} //<>//

void selectOrderedImage(File selection) {
  PImage img = loadImage(selection.getAbsolutePath()); 
  
  int matrixSize = 4;
  
  float[][] matrix = {{0, 8, 2, 10},{12, 4, 14, 6},{3, 11, 1, 9},{15, 7, 13, 5}};
  for (int i = 0; i < matrix.length; i++) {
    float[] row = matrix[i];
    for (int j = 0; j < row.length; j++) {
      matrix[i][j] = row[j]/(matrixSize*matrixSize); 
    }
  }
  
  for (int x = 0; x < width; x+= matrixSize) {
    for (int y = 0; y < height; y+= matrixSize) {
      for (int i = 0; i < matrix.length; i++) {
        float[] row = matrix[i];
        for (int j = 0; j < row.length; j++) {
          int newX = x + i;
          int newY = y + j;
          if (newX < width && newY < height) {
            float val = row[j] + random(matrixSize*matrixSize*-1/256, matrixSize*matrixSize/256);
            float r = red(img.get(newX,newY));
            float g = green(img.get(newX,newY));
            float b = blue(img.get(newX,newY));
            r = r < val ? 0 : 1;
            g = g < val ? 0 : 1;
            b = b < val ? 0 : 1;
            set(newX, newY, color(r,g,b)); 
          }
        }
      }
    }
  }
  save("Ordered.jpg");
}


void selectDotImage(File selection) {
  PImage img = loadImage(selection.getAbsolutePath()); 
  
  int matrixSize = 5;
  
  float[][] matrix = {{0, 8, 2, 10},{12, 4, 14, 6},{3, 11, 1, 9},{15, 7, 13, 5}};
  for (int i = 0; i < matrix.length; i++) {
    float[] row = matrix[i];
    for (int j = 0; j < row.length; j++) {
      matrix[i][j] = row[j]/(matrixSize*matrixSize); 
    }
  }
  
  for (int x = 0; x < width; x+= matrixSize) {
    for (int y = 0; y < height; y+= matrixSize) {
      for (int i = 0; i < matrix.length; i++) {
        float[] row = matrix[i];
        for (int j = 0; j < row.length; j++) {
          int newX = x + i;
          int newY = y + j;
          if (newX < width && newY < height) {
            float val = row[j] + random(matrixSize*matrixSize*-1/256, matrixSize*matrixSize/256);
            float r = red(img.get(newX,newY));
            float g = green(img.get(newX,newY));
            float b = blue(img.get(newX,newY));
            r = r < val ? 0 : 1;
            g = g < val ? 0 : 1;
            b = b < val ? 0 : 1;
            set(newX, newY, color(r,g,b)); 
          }
        }
      }
    }
  }
  save("Ordered.jpg");
}
