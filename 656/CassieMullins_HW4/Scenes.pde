import java.io.*;
import java.util.*;

void readFromFile(File selection) {
  ArrayList<Material> materialList = new ArrayList<Material>();
  ArrayList<Light> newLightList = new ArrayList<Light>();
  ArrayList<Shape> newShapeList = new ArrayList<Shape>();
  
  name = selection.getName();
  name = name.substring(0, name.length() - 4);
   try {
     BufferedReader reader = new BufferedReader(new FileReader(selection.getAbsolutePath()));
     String line = reader.readLine();
     
     while (line != null) { //Parse each line in the file in turn
       println(line);
       if (!line.isEmpty()) {
          String[] words = line.split(" "); //split the line into individual tokens
       
           if (words.length <= 1 || words[0].charAt(0) == '#') { //skip empty lines & comments
             println("Do Nothing");
           } else if (words[0].equals("Camera")) {
             println("Camera");
              Pe = new Vector(Float.parseFloat(words[1]),Float.parseFloat(words[2]),Float.parseFloat(words[3]));
              Vector Vview = new Vector(Float.parseFloat(words[4]),Float.parseFloat(words[5]),Float.parseFloat(words[6]));
              Vector vup = new Vector(Float.parseFloat(words[7]), Float.parseFloat(words[8]), Float.parseFloat(words[9]));
              float d = Float.parseFloat(words[12]);
              s0 = Float.parseFloat(words[10]);
              s1 = Float.parseFloat(words[11]);
              
              n0 = Vview.Cross(vup);
              n0.Normalize();  
              
              Vector n2 = Vview;
              n2.Normalize();

              n1 = n0.Cross(n2);
              
              
              Vector Pc = Pe.Add(n2.Mult(d));
              println(Pc.toString());
              println(n0.toString());
              println(n1.toString());
              println(n2.toString());
              
              P00 = Pc.Sub((n0.Mult(s0).Add(n1.Mult(s1))).Div(2));
              println(P00.toString());
           } else if (words[0].equals("Material")) {
             println("Material");
              materialList.add(new Material(new Vector(Float.parseFloat(words[1]),Float.parseFloat(words[2]),Float.parseFloat(words[3])), 
              new Vector(Float.parseFloat(words[4]),Float.parseFloat(words[5]),Float.parseFloat(words[6])), 
              new Vector(Float.parseFloat(words[7]),Float.parseFloat(words[8]),Float.parseFloat(words[9])), 
              Float.parseFloat(words[10]), Float.parseFloat(words[11]), 
              words.length > 12 ? new Vector(Float.parseFloat(words[12]), Float.parseFloat(words[13]), Float.parseFloat(words[14])) : null,
              words.length > 12 ? Float.parseFloat(words[15]) : 0));
           } else if (words[0].equals("Sphere")) {
             println("Sphere");
              newShapeList.add(new Sphere(new Vector(Float.parseFloat(words[1]),Float.parseFloat(words[2]),Float.parseFloat(words[3])), 
              Float.parseFloat(words[4]), materialList.get(Integer.parseInt(words[5]))));    
           } else if (words[0].equals("Plane")) {
             println("Plane");
             newShapeList.add(new Plane(new Vector(Float.parseFloat(words[1]),Float.parseFloat(words[2]),Float.parseFloat(words[3])), 
             materialList.get(Integer.parseInt(words[4])), new Vector(Float.parseFloat(words[5]),Float.parseFloat(words[6]),Float.parseFloat(words[7]))));
           } else if (words[0].equals("Point")) {
             println("Point");
              newLightList.add(new Point(new Vector(Float.parseFloat(words[1]),Float.parseFloat(words[2]),Float.parseFloat(words[3])), 
              new Vector(Float.parseFloat(words[4]),Float.parseFloat(words[5]),Float.parseFloat(words[6]))));
           } else if (words[0].equals("Direction")) {
             println("Direction");
             newLightList.add(new Direction(new Vector(Float.parseFloat(words[1]),Float.parseFloat(words[2]),Float.parseFloat(words[3])), 
             new Vector(Float.parseFloat(words[4]),Float.parseFloat(words[5]),Float.parseFloat(words[6]))));
           } else if (words[0].equals("Spotlight")) {
             newLightList.add(new Spotlight(new Vector(Float.parseFloat(words[1]), Float.parseFloat(words[2]), Float.parseFloat(words[3])), 
             new Vector(Float.parseFloat(words[4]),Float.parseFloat(words[5]),Float.parseFloat(words[6])), 
             new Vector(Float.parseFloat(words[7]),Float.parseFloat(words[8]),Float.parseFloat(words[9])), cos(radians(Float.parseFloat(words[10])))));
           } else if (words[0].equals("Quadric")) {
             newShapeList.add(new Quadric(Integer.parseInt(words[1]), Integer.parseInt(words[2]), Integer.parseInt(words[3]), Integer.parseInt(words[4]), Integer.parseInt(words[5]), 
             Float.parseFloat(words[6]), Float.parseFloat(words[7]), Float.parseFloat(words[8]),
             new Vector(Float.parseFloat(words[9]), Float.parseFloat(words[10]), Float.parseFloat(words[11])), new Vector(Float.parseFloat(words[12]), Float.parseFloat(words[13]), Float.parseFloat(words[14])), 
             new Vector(Float.parseFloat(words[15]), Float.parseFloat(words[16]), Float.parseFloat(words[17])), materialList.get(Integer.parseInt(words[18]))));
           }
        }
        line = reader.readLine();
     }
     println("Close Reader");
     reader.close();
     
     shapeList = new Shape[newShapeList.size()];
     for (int i = 0; i < shapeList.length; i++) {
       shapeList[i] = newShapeList.get(i); 
     }
     
     lightList = new Light[newLightList.size()];
     for (int i = 0; i < lightList.length; i++) {
       lightList[i] = newLightList.get(i); 
     }
     
     render();
    save("Renders//" + name + "Render.png");
   } catch (Exception e) {
     println(e.toString() + " caught in interpreter");
  }  
}
