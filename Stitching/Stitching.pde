/*
* Cassie Mullins
* VIZA 654
* Created in Processing with Java
* 
* 1 - Select and Image and it will be scaled down to a width of 500 using seam carving
* 2 - Select 2 Images (left image first) and they will be stitched together
*/

boolean hasText = true;
PImage firstImg;

void setup() {
   colorMode(RGB, 1.0);
   background(0,0,0);
   size(600,600);
   surface.setResizable(true);
   
   setText();
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
  text("1 - Seam Carving", 20, 50);
  text("2 - Image Stitching (Select Left First)", 20, 90);
}

void keyPressed() {
  hasText = false;
  if (key == '1') {
    selectInput("Select an image to blur", "selectSeamCarveImg"); 
  } else if (key == '2') {
    selectInput("Select an image to blur", "selectStitchingFirstImage"); 
  }
}

void selectSeamCarveImg(File selection) {
  surface.setSize(500,600);
  PImage img = loadImage(selection.getAbsolutePath());
  int currentWidth = img.width;
  int desiredWidth = width;
  color[][] colors = new color[img.width][img.height];
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      colors[x][y] = img.get(x,y); 
    }
  }
  while (currentWidth > desiredWidth) {
    int[] seam = new int[img.height];
    int startingIndex = 1;
    int endingIndex = colors.length - 2;
    for (int y = colors[0].length/2; y < colors[0].length; y++) {
      float leastDiff = 2;
      for (int x = startingIndex; x <= endingIndex; x++) {
        if (x > 0 && x < colors.length - 1) {
          color prevColor = colors[x - 1][y];
          color nextColor = colors[x + 1][y];
          
          float redDiff = abs(red(nextColor) - red(prevColor));
          float greenDiff = abs(green(nextColor) - green(prevColor));
          float blueDiff = abs(blue(nextColor) - blue(prevColor));
          float avgDiff = (redDiff + greenDiff + blueDiff)/3;
          if (avgDiff < leastDiff) {
            leastDiff = avgDiff;
            seam[y] = x;
          } 
        }
      }
      startingIndex = seam[y] - 1;
      endingIndex = seam[y] + 1;
    }
    startingIndex = seam[colors[0].length/2] - 1;
    endingIndex = seam[colors[0].length/2] + 1;
    for (int y = colors[0].length/2 - 1; y >= 0; y--) {
      float leastDiff = 2;
      for (int x = startingIndex; x <= endingIndex; x++) {
        if (x > 0 && x < colors.length - 1) {
          color prevColor = colors[x - 1][y];
          color nextColor = colors[x + 1][y];
          
          float redDiff = abs(red(nextColor) - red(prevColor));
          float greenDiff = abs(green(nextColor) - green(prevColor));
          float blueDiff = abs(blue(nextColor) - blue(prevColor));
          float avgDiff = (redDiff + greenDiff + blueDiff)/3;
          if (avgDiff < leastDiff) {
            leastDiff = avgDiff;
            seam[y] = x;
          } 
        }
      }
      startingIndex = seam[y] - 1;
      endingIndex = seam[y] + 1;
    }
    color[][] newColors = new color[colors.length - 1][colors[0].length];
    for (int y = 0; y < colors[0].length; y++) {
      int newIndex = 0;
      for (int x = 0; x < colors.length; x++) {
        if (seam[y] != x) {
          newColors[newIndex][y] = colors[x][y];
          newIndex++;
        }
      }
    }
    colors = newColors;
    currentWidth--;
  }
  for (int x = 0; x < colors.length; x++) {
    for (int y = 0; y < colors[0].length; y++) {
      set(x,y,colors[x][y]);
    }
  }
  save("CarvedImage.jpg");
}

void selectStitchingFirstImage(File selection) {
  firstImg = loadImage(selection.getAbsolutePath());
  selectInput("Select an image to blur", "selectStitchingSecondImage"); 
}


void selectStitchingSecondImage(File selection) {
  PImage secondImg = loadImage(selection.getAbsolutePath());
  
  float minAvgDiff = 2;
  int indexMinDiff = 0;
  for (int i = 0; i < secondImg.width; i++) {
    int firstImgStart = firstImg.width - i - 1;
    int firstImgEnd = firstImg.width - i;
    int secondImgStart = 0;
    int secondImgEnd = i + 1;
    
    float totalDiff = 0;
    for (int x = secondImgStart; x < secondImgEnd; x++) {
      for (int y = 0; y < firstImg.height; y++) {
        color firstCol = firstImg.get(firstImgStart + x, y);
        color secondCol = secondImg.get(x,y);
        
        float redDiff = abs(red(firstCol) - red(secondCol));
        float greenDiff = abs(green(firstCol) - green(secondCol));
        float blueDiff = abs(blue(firstCol) - blue(secondCol));
        totalDiff += (redDiff + greenDiff + blueDiff)/3;
      }
    }
    totalDiff = totalDiff/((secondImgEnd - secondImgStart)*firstImg.height);
    if (totalDiff < minAvgDiff) {
      minAvgDiff = totalDiff;
      indexMinDiff = i;
    }
  }
  
  int secondImgStart = firstImg.width - 1 - indexMinDiff;
  surface.setSize(firstImg.width + secondImg.width - indexMinDiff, firstImg.height);
  color[][] colors = new color[width][height];
  
  for (int x = 0; x < secondImgStart; x++) {
    for (int y = 0; y < height; y++) {
      if (x < firstImg.width) {
       colors[x][y] = firstImg.get(x, y); 
      }
    }
  }
  for (int x = firstImg.width; x < width; x++) {
    for (int y = 0; y < height; y++) {
      colors[x][y] = secondImg.get(x - secondImgStart, y); 
    }
  }
  
  int[] seam = new int[height];
  int startingIndex = 1;
  int endingIndex = indexMinDiff - 1;
  for (int y = height/2; y < height; y++) {
    float leastDiff = 2;
    for (int x = startingIndex; x <= endingIndex; x++) {
       if (x > 0 && x < colors.length - 1) {
         color prevColor = secondImg.get(x - 1, y);
         color nextColor = secondImg.get(x + 1, y);
          
         float redDiff = abs(red(nextColor) - red(prevColor));
         float greenDiff = abs(green(nextColor) - green(prevColor));
         float blueDiff = abs(blue(nextColor) - blue(prevColor));
         float avgDiff = (redDiff + greenDiff + blueDiff)/3;
         if (avgDiff < leastDiff) {
           leastDiff = avgDiff;
           seam[y] = x;
         } 
       }
     }
     startingIndex = seam[y] - 1;
     endingIndex = seam[y] + 1;
   }
   startingIndex = seam[colors[0].length/2] - 1;
   endingIndex = seam[colors[0].length/2] + 1;
   for (int y = height/2 - 1; y >= 0; y--) {
     float leastDiff = 2;
     for (int x = startingIndex; x <= endingIndex; x++) {
       if (x > 0 && x < colors.length - 1) {
         color prevColor = secondImg.get(x - 1, y);
         color nextColor = secondImg.get(x + 1, y);
          
         float redDiff = abs(red(nextColor) - red(prevColor));
         float greenDiff = abs(green(nextColor) - green(prevColor));
         float blueDiff = abs(blue(nextColor) - blue(prevColor));
         float avgDiff = (redDiff + greenDiff + blueDiff)/3;
         if (avgDiff < leastDiff) {
           leastDiff = avgDiff;
           seam[y] = x;
         } 
       }
     }
     startingIndex = seam[y] - 1;
     endingIndex = seam[y] + 1;
  }
   for (int x = secondImgStart; x < firstImg.width; x++) {
    for (int y = 0; y < height; y++) {
      if (x - secondImgStart < seam[y]) {
        colors[x][y] = firstImg.get(x, y); 
      } else {
       colors[x][y] = secondImg.get(x - secondImgStart, y); 
      }
    }
  }

  for (int x = 0; x < colors.length; x++) {
    for (int y = 0; y < colors[0].length; y++) {
      set(x,y,colors[x][y]);
    }
  }
  save("StitchedImage.jpg");
}
