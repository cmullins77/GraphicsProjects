/*
* Cassie Mullins
* VIZA 654
*
* 1 - Random Noise, 2 - Error, 3 - Ordered, 4 - Interactive in Black & White, 5 - Interactive in Color
* Choose Foreground First and then Background
* Note: you may have to rerun the program to switch between the 2 versions of the interactive program
*/

  

void setup() {
   background(0,0,0);
   size(600,600);
   colorMode(RGB, 1.0);
   setText();
}

void draw() {
  
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
  if (key == '1') {
      selectInput("Select Image to Add Random Noise to", "selectRandomNoiseImage");
   }
} //<>// //<>//
