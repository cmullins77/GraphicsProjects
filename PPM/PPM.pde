/*
 * By Cassie Mullins
 * Program 1
 * Reading a PPM File
 * Written for Processing Java
 *
 * 1: Read a P3 or a P6 PPM and Display in Processing
 * 2: Read an Image File and Generate a P3 PPM
 * 3: Read an Image File, Apply a Glitch Effect, Display in Processing, and Generate a P3 PPM
 */
import java.io.*;
import java.util.*;
 
PImage img;
 
boolean keyPress = false;
 
void setup() {
  //Setup Window
  background(0,0,0);
  size(800,400);
  surface.setResizable(true);
  
}

void draw() {
  if (!keyPress) {
    fill(255);
    textSize(24);
    text("Press 1 to Read and Display either P3 or P6 PPM", 50, 100);
    text("Press 2 to Generate a P3 PPM from Image", 50, 200);
    text("Press 3 to Apply Glitch Effect to Image and Generate a P3 PPM", 50, 300);
  }
}

void keyPressed() {
  if (key == '1') {
    keyPress = true;
    //Prompt for PPM selection
    selectInput("Select a file to process:", "readAndDisplayPPM");
  } else if (key == '2') {
    keyPress = true;
    selectInput("Select a file to process:", "generatePPM");
  } else if (key == '3') {
    keyPress = true;
    selectInput("Select a file to process:", "generateGlitchImage");
  }
}

/*
 * Check if PPM was selected and then Read Header and Set Colors
 */
void readAndDisplayPPM(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    colorMode(RGB, 1.0);
    
    try {
      //Create a new Input Stream
      InputStream iS = new FileInputStream(selection.getAbsolutePath());
      
      //Get the Type from the first 2 chars in the file
      int type = getPPMType(iS);
      
      //if type is 0 this is not a PPM
      if (type == 0) {
        println("Not a valid PPM - incorrect header");
        return;
      }
      
      setScreenSizeFromPPM(iS);
      
      float maxColor = readNextNum(iS);
      
      //Call function to set the colors using the rest of the PPM
      setColors(iS, maxColor, type == 3);
    } catch (Exception e) {
      println(e.toString() + " caught in openPPM.");
    }        
  }
}

//Turn Image into P3 PPM - Key 2
void generatePPM(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    
    try {
      println("User selected " + selection.getAbsolutePath());
      PImage img = loadImage(selection.getAbsolutePath());
      
      PrintWriter output = createWriter(selection.getName() + ".ppm");
      writeP3Header(output, new PVector(img.width, img.height));
      writeColors(output, img);
     
      output.flush();
      output.close();

    } catch (Exception e) {
      println(e.toString() + " caught in generate PPM.");
    }
  }
}

void generateGlitchImage(File selection) {
  colorMode(RGB, 255);
  color[][][] colors;
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    
    surface.setSize(600,400);
    
    colors = generateStripes();
  } else {
    println("User selected " + selection.getAbsolutePath());
    
    PImage img = loadImage(selection.getAbsolutePath());
    surface.setSize(img.width, img.height);
    
    colors = getAllColors(img);
  }
  
  color[][] newColor = shiftColors(colors[0], colors[1]);
  newColor = addBars(newColor);
      
  String name = selection == null ? "GlitchEffect.jpg" : "GlitchEfffect_" + selection.getName(); //<>//
  PrintWriter output = createWriter(name + ".ppm");
  
  writeP3Header(output, new PVector(width, height));
      
  writeColors(output, newColor);
        
  output.flush();
  output.close();
      
  save(name);
}

/*
 * Set the pixel colors based on PPM Data
 */
void setColors(InputStream input, float maxColor, boolean isAscii) {
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      float redCol = 0;
      float greenCol = 0; 
      float blueCol = 0;
      try {   
        if (isAscii) {
          redCol = readNextNum(input)/maxColor;
          greenCol = readNextNum(input)/maxColor;
          blueCol = readNextNum(input)/maxColor;
        } else {
          //If Binary, read the next byte and divide by max color to get colors
          //if color is -1 that means that we have run out of image data and the rest of the image will be the blac background
          redCol = input.read()/maxColor;
          greenCol = input.read()/maxColor;
          blueCol = input.read()/maxColor;
       }
     } catch (Exception e) {
       println(e.toString() + " found setting colors");
     }
      
      //Set the actual pixel color
      set(x, y, color(redCol, greenCol, blueCol));
    }    
  }
}

//Read the next full number in the input stream as a float valu
float readNextNum(InputStream input) {
  String numString = "";
  
  try {
    char currChar = (char) input.read();
    //Current Char is not a number (space, newline, comment, etc)
    while (currChar < 48 || currChar > 57) {
      //The Line is a comment read until next line
      if (currChar == '#') {
        while (currChar != '\n') {
          currChar = (char) input.read();
        }
      }
      currChar = (char) input.read();
    }
    //Read the current number until newline or space is hit
    while (currChar != '\n' && currChar != ' ') {
      numString = numString + currChar;
      int num = input.read();
      if (num == -1) {
        currChar = ' ';
      } else {
        currChar = (char) num;
      }
    }
  } catch (Exception e) {
      println(e.toString() + " caught reading Num");
  }  

  return Float.parseFloat(numString);
}

 //Get the Type from the first 2 chars in the file
 //0 - Nothing, 3 - P3, 6 - P6
int getPPMType(InputStream input) {
  String type= "";
  
  try {
    type = type + (char) input.read() + (char) input.read();
    input.read();
  } catch (IOException e) {
    println(e.toString() + " caught reading Type");
  }
 
  return type.equals("P3") ? 3 : type.equals("P6") ? 6 : 0;
}

PVector setScreenSizeFromPPM(InputStream input) {
  PVector size = new PVector (0,0);
  
  //Read first number as width and then next number as height
  size.x = readNextNum(input);
  size.y = readNextNum(input);
      
  //Set the Screen width and height and surface size
  surface.setSize((int)size.x, (int)size.y);
  
  return size;
}

void writeP3Header(PrintWriter output, PVector size) {
   output.println("P3");
   output.println(size.x + " " + size.y);
   output.println("255");
}

void writeColors(PrintWriter output, PImage img) {
  colorMode(RGB, 255);
  for (int y = img.height - 1; y >= 0; y--) {
    for (int x = img.width - 1; x >= 0; x--) {
      color c = img.get(x, y);
      int red = (int)(red(c));
      int green = (int)(green(c));
      int blue = (int)(blue(c));
      output.println(red + " " + green + " " + blue);
    }
  }
}

void writeColors(PrintWriter output, color[][] colors) {
  colorMode(RGB, 255); //<>//
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int red = (int) red(colors[y][x]);
      int green = (int) green(colors[y][x]);
      int blue = (int) blue(colors[y][x]);
      set(x,y, color(red,green,blue));
      output.println(red + " " + green + " " + blue);
    }
  }
}

color[][][] getAllColors(PImage img) {
  color[][][] colors = new color[2][height][width];
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      colors[0][y][x] = color(red(img.get(x,y)), green(img.get(x,y)), blue(img.get(x,y))); 
      colors[1][y][x] = color(red(img.get(x,y)), green(img.get(x,y)), blue(img.get(x,y))); 
    }
  }
  
  return colors;
}

color[][][] generateStripes() {
  color[][][] colors = new color[2][height][width];
  
  ArrayList<Integer> stripeNums = new ArrayList<Integer>();
  for (int i = 0; i < width; i = i + (int)random(100)) {
    stripeNums.add(new Integer(i));
  }
  stripeNums.add(new Integer(width));
    
  int stripeIndex = 0;
  for (int x = 0; x < width; x++) {
    int col;
    if (stripeIndex % 2 == 0) {
      col = 0;
    } else {
      col = 255;
    }
    for (int y = 0; y < height; y++) {
      colors[0][y][x] = color(col, col, col); 
      colors[1][y][x] = color(col, col, col); 
    }
    if (x == stripeNums.get(stripeIndex)) {
      stripeIndex++;
    }
  }
  
  return colors;
}

color[][] shiftColors(color[][] oldColors, color[][] newColors) {
  int shiftNum = (int)(random(10,20)*exp(0.0004*width));
  for (int i = 0; i < height; i++) {
    for (int j = 0; j < width - shiftNum; j++) {
      newColors[i][j] = color(red(oldColors[i][j+shiftNum]), green(newColors[i][j]), blue(newColors[i][j]));
      newColors[i][j + shiftNum] = color(newColors[i][j+shiftNum], green(newColors[i][j+shiftNum]), blue(oldColors[i][j]));
    }
  } 
  return newColors;
}

color[][] addBars(color[][] colors) {
  int shiftHeight = (int)random(5)+1;
  int shiftAmount = (int)random(6);
  for (int i = 0; i < height; i++) {
    boolean shiftRight = random(1) > 0.5;
    if (shiftRight) {
      for (int j = 0; j < width - shiftAmount; j++) {
        colors[i][j] = colors[i][j+shiftAmount];
      }  
    } else {
      for (int j = shiftAmount; j < width; j++) {
        colors[i][j - shiftAmount] = colors[i][j];
      }  
    }
    shiftHeight--;
    if (shiftHeight == 0) {
      i = i + (int)random(10);
      shiftHeight = (int)random(3)+1;
      shiftAmount = (int)random(6);
    }
  }
  return colors;
}
