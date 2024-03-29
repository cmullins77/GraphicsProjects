import java.io.*;
import java.util.*;

void readFromFile(File selection) {
  int shapeIndex = 0;
  ArrayList<Material> materialList = new ArrayList<Material>();
  ArrayList<Light> newLightList = new ArrayList<Light>();
  ArrayList<Shape> newShapeList = new ArrayList<Shape>();
  animator = new Animator();
  isAnimation = false;
  
  name = selection.getName();
  name = name.substring(0, name.length() - 4);
   try {
     BufferedReader reader = new BufferedReader(new FileReader(selection.getAbsolutePath()));
     String line = reader.readLine();
     
     while (line != null) { //Parse each line in the file in turn
       println(line);
       if (!line.isEmpty()) {
          String[] words = line.split(" "); //split the line into individual tokens
       
           if (words.length <= 1) { //skip empty lines
             println("Do Nothing");
           } else if (words[0].equals("Camera")) {
             convertCamera(words);
           } else if (words[0].equals("Material")) {
              materialList.add(convertMaterial(words));
           } else if (words[0].equals("Sphere")) {
             println("Sphere");
             newShapeList.add(new Sphere(new Vector(Float.parseFloat(words[1]),Float.parseFloat(words[2]),Float.parseFloat(words[3])), 
             Float.parseFloat(words[4]), materialList.get(Integer.parseInt(words[5])), shapeIndex));    
             shapeIndex++;
           } else if (words[0].equals("Cube")) {
            println("Cube");
            newShapeList.add(new Cube(new Vector(Float.parseFloat(words[1]),Float.parseFloat(words[2]),Float.parseFloat(words[3])), 
            new Vector(Float.parseFloat(words[4]),Float.parseFloat(words[5]),Float.parseFloat(words[6])), 
            materialList.get(Integer.parseInt(words[7])), shapeIndex));    
            shapeIndex++;
          } else if (words[0].equals("Tetrahedron")) {
              println("Tetrahedron");
              newShapeList.add(new Tetrahedron(new Vector(Float.parseFloat(words[1]),Float.parseFloat(words[2]),Float.parseFloat(words[3])), 
              new Vector(Float.parseFloat(words[4]),Float.parseFloat(words[5]),Float.parseFloat(words[6])), 
              materialList.get(Integer.parseInt(words[7])), shapeIndex));    
              shapeIndex++;
            } else if (words[0].equals("EnvMap")) {
             println("InfiniteSphere");
              newShapeList.add(new InfiniteSphere(materialList.get(Integer.parseInt(words[1])), shapeIndex));    
              shapeIndex++;
           } else if (words[0].equals("Plane")) {
             println("Plane");
             Plane p = new Plane(new Vector(Float.parseFloat(words[1]),Float.parseFloat(words[2]),Float.parseFloat(words[3])), 
             materialList.get(Integer.parseInt(words[4])), new Vector(Float.parseFloat(words[5]),Float.parseFloat(words[6]),Float.parseFloat(words[7])), shapeIndex);
             newShapeList.add(p);
             shapeIndex++;
           } else if (words[0].equals("Triangle")) {
             println("Triangle");
             Triangle t = new Triangle(new Vector(Float.parseFloat(words[1]),Float.parseFloat(words[2]),Float.parseFloat(words[3])), 
             new Vector(Float.parseFloat(words[4]),Float.parseFloat(words[5]),Float.parseFloat(words[6])), 
             new Vector(Float.parseFloat(words[7]),Float.parseFloat(words[8]),Float.parseFloat(words[9])), 
             materialList.get(Integer.parseInt(words[10])), shapeIndex);
             newShapeList.add(t);
             shapeIndex++;
           }  else if (words[0].equals("OBJ")) {
             println("OBJ");
             OBJ o = new OBJ(new Vector(Float.parseFloat(words[1]),Float.parseFloat(words[2]),Float.parseFloat(words[3])), 
             sketchPath() + "\\ObjectFiles\\" + words[4],
             materialList.get(Integer.parseInt(words[5])), shapeIndex);
             newShapeList.add(o);
             shapeIndex++;
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
           } else if (words[0].equals("RectangleArea")) {
             int count0 = Integer.parseInt(words[15]); //<>//
             int count1 = Integer.parseInt(words[16]);
             newLightList.add(new RectangleArea(new Vector(Float.parseFloat(words[1]), Float.parseFloat(words[2]), Float.parseFloat(words[3])), 
             new Vector(Float.parseFloat(words[4]), Float.parseFloat(words[5]), Float.parseFloat(words[6])), 
             Float.parseFloat(words[7]), Float.parseFloat(words[8]),
             new Vector(Float.parseFloat(words[9]), Float.parseFloat(words[10]), Float.parseFloat(words[11])), 
             new Vector(Float.parseFloat(words[12]), Float.parseFloat(words[13]), Float.parseFloat(words[14])), count0, count1));
           } else if (words[0].equals("Quadric")) {
             newShapeList.add(new Quadric(Integer.parseInt(words[1]), Integer.parseInt(words[2]), Integer.parseInt(words[3]), Integer.parseInt(words[4]), Integer.parseInt(words[5]), 
             Float.parseFloat(words[6]), Float.parseFloat(words[7]), Float.parseFloat(words[8]),
             new Vector(Float.parseFloat(words[9]), Float.parseFloat(words[10]), Float.parseFloat(words[11])), new Vector(Float.parseFloat(words[12]), Float.parseFloat(words[13]), Float.parseFloat(words[14])), 
             new Vector(Float.parseFloat(words[15]), Float.parseFloat(words[16]), Float.parseFloat(words[17])), materialList.get(Integer.parseInt(words[18])), shapeIndex));
             shapeIndex++;
           } else if (words[0].equals("NormalMap")) {
             generateNormalMap = true;
           } else if (words[0].equals("Animation")) {
             isAnimation = true;
             frames = Integer.parseInt(words[1]);
             motionBlurFrames = Integer.parseInt(words[2]);
           } else if (words[0].equals("Animate")) {
             convertAnimation(words);
           }
        }
        line = reader.readLine();
     }
     println("Close Reader"); //<>//
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
   } catch (Exception e) {
     println(e.toString() + " caught in interpreter");
  }  
}

void convertCamera(String[] data) {
  Vector Vview = new Vector(0, 0, -1);
  Vector Vup = new Vector(0, 1, 0);
  Pe = new Vector(0, 0, 0);
  float d = 1;
  s0 = 1;
  s1 = 1;
  lensSize = 0.001f;
  lensAliasSize = 1;
  
  for (String element : data) {
    String[] list = element.split(",");
       switch(list[0]) {
         case "Pos":
            Pe = new Vector(Float.parseFloat(list[1]), Float.parseFloat(list[2]), Float.parseFloat(list[3]));
            break;
        case "View":
            Vview = new Vector(Float.parseFloat(list[1]), Float.parseFloat(list[2]), Float.parseFloat(list[3]));
            break;
        case "Up":
            Vup = new Vector(Float.parseFloat(list[1]), Float.parseFloat(list[2]), Float.parseFloat(list[3]));
            break;
        case "Distance":
            d = Float.parseFloat(list[1]);
            break;
        case "Size":
            s0 = Float.parseFloat(list[1]);
            s1 = Float.parseFloat(list[2]);
            break;
        case "LensSize":
            lensSize = Float.parseFloat(list[1]);
            lensAliasSize = Integer.parseInt(list[2]);
            break;
        default:
          break;
     }
  }
  
  n0 = Vview.Cross(Vup);
  n0.Normalize();  
  
  n2 = Vview;
  n2.Normalize();
  
  n1 = n0.Cross(n2);
  
  Vector Pc = Pe.Add(n2.Mult(d));
  P00 = Pc.Sub((n0.Mult(s0).Add(n1.Mult(s1))).Div(2));
}

void convertAnimation(String[] data) {
  int startFrame = 0;
  int endFrame = 0;
  int object = 0;
  int type = 0;
  float[] info = {0};
  
  for (String element : data) {
    String[] list = element.split(",");
       switch(list[0]) {
         case "Start":
            startFrame = Integer.parseInt(list[1]);
            break;
        case "End":
            endFrame = Integer.parseInt(list[1]);
            break;
        case "Object":
            object = Integer.parseInt(list[1]);
            break;
        case "Translate":
            type = 0;
            float[] newInfo = {Float.parseFloat(list[1]),Float.parseFloat(list[2]),Float.parseFloat(list[3])};
            info = newInfo;
            break;
        case "Scale":
            type = 1;
            float[] newInfo2 = {Float.parseFloat(list[1]),Float.parseFloat(list[2]),Float.parseFloat(list[3])};
            info = newInfo2;
            break;
         case "RotateX":
            type = 2;
            float[] newInfo3 = {radians(Float.parseFloat(list[1]))};
            info = newInfo3;
            break;
         case "RotateY":
            type = 3;
            float[] newInfo4 = {radians(Float.parseFloat(list[1]))};
            info = newInfo4;
            break;
         case "RotateZ":
            type = 4;
            float[] newInfo5 = {radians(Float.parseFloat(list[1]))};
            info = newInfo5;
            break;
        default:
          break;
     }
  }
  int[] params = {object, startFrame, endFrame};
  animator.parameters.add(params);
  if (info.length == 1) {
    float[] newData = {type, info[0]};
    animator.animations.add(newData);
  } else {
    float[] newData = {type, info[0], info[1], info[2]};
    animator.animations.add(newData);
  }
}

Material convertMaterial(String[] data) {
  Material newMat = new Material();
  
  for (String element : data) {
    String[] list = element.split(",");
       switch(list[0]) {
         case "dark":
           if (list.length == 2) {
              PImage c0 = loadImage("Textures\\" + list[1]);
              newMat.addColor(c0, 0);
            } else {
              Vector c0 = new Vector(Float.parseFloat(list[1]), Float.parseFloat(list[2]), Float.parseFloat(list[3]));
              newMat.addColor(c0, 0);
            }
            break;
        case "light":
           if (list.length == 2) {
              PImage c1 = loadImage("Textures\\" + list[1]);
              newMat.addColor(c1, 1);
            } else {
              Vector c1 = new Vector(Float.parseFloat(list[1]), Float.parseFloat(list[2]), Float.parseFloat(list[3]));
              newMat.addColor(c1, 1);
            }
            break;
        case "specular":
          if (list.length == 2) {
            PImage cP = loadImage("Textures\\" + list[1]);
            newMat.addColor(cP, 2);
          } else {
            Vector cP = new Vector(Float.parseFloat(list[1]), Float.parseFloat(list[2]), Float.parseFloat(list[3]));
            newMat.addColor(cP, 2);
          }
          break;
        case "Ks":
          newMat.Ks = Float.parseFloat(list[1]);
          break;
        case "P":
          newMat.P = Float.parseFloat(list[1]);
          break;
        case "TileSize":
          newMat.tileSize = Float.parseFloat(list[1]);
          break;
        case "NormalMap":
          newMat.NormalMap = loadImage("Textures\\" + list[1]);
          break;
        case "Krefl":
          newMat.Krefl = Float.parseFloat(list[1]);
          break;
        case "Krefr":
          newMat.Krefr = Float.parseFloat(list[1]);
          break;
        case "n":
          float n = Float.parseFloat(list[1]) - 1;
          newMat.N = newMat.convertColor(new Vector(n,n,n));
          break;
        case "N":
          newMat.N = loadImage("Textures\\" + list[1]);
          newMat.isRefractionTexture = true;
          break;
        case "BorderCol":
          newMat.borderColor = new Vector(Float.parseFloat(list[1]), Float.parseFloat(list[2]), Float.parseFloat(list[3]));
          break;
        case "BorderThickness":
          newMat.thickness = Float.parseFloat(list[1]);
          break;
        case "Projection":
          newMat.isProjectionTexture = true;
          break;
        case "Smooth":
          newMat.isSmoothShading = true;
          break;
        case "EnvMap":
          Material mapMat = new Material();
          PImage background =  loadImage("Textures\\" + list[1]);
          mapMat.addColor(background, 0);
          mapMat.addColor(background, 1);
          Shape map = new InfiniteSphere(mapMat, -1);
          newMat.envMap = map;
          break;
        case "DRTRange":
          newMat.drtRange = Float.parseFloat(list[1]);
          break;
        default:
          break;
     }
  }
   
   return newMat;
}
